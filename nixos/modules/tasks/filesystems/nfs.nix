{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

  nfsStateDir = "/var/lib/nfs";

  rpcMountpoint = "${nfsStateDir}/rpc_pipefs";

  idmapdConfFile = pkgs.writeText "idmapd.conf" ''
    [General]
    Pipefs-Directory = ${rpcMountpoint}
    ${optionalString (config.networking.domain != null)
      "Domain = ${config.networking.domain}"}

    [Mapping]
    Nobody-User = nobody
    Nobody-Group = nogroup

    [Translation]
    Method = nsswitch
  '';

  cfg = config.services.nfs;

in

{
  ###### interface

  options = {

    services.nfs = {
      statdPort = mkOption {
        default = null;
        example = 4000;
        description = ''
          Use fixed port for rpc.statd, useful if NFS server is behind firewall.
        '';
      };
      lockdPort = mkOption {
        default = null;
        example = 4001;
        description = ''
          Use fixed port for NFS lock manager kernel module (lockd/nlockmgr),
          useful if NFS server is behind firewall.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf (any (fs: fs == "nfs" || fs == "nfs4") config.boot.supportedFilesystems) {

    services.rpcbind.enable = true;

    system.fsPackages = [ pkgs.nfs-utils ];

    boot.extraModprobeConfig = mkIf (cfg.lockdPort != null) ''
      options lockd nlm_udpport=${toString cfg.lockdPort} nlm_tcpport=${toString cfg.lockdPort}
    '';

    boot.kernelModules = [ "sunrpc" ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    systemd.services.statd =
      { description = "NFSv3 Network Status Monitor";

        path = [ pkgs.nfs-utils pkgs.sysvtools pkgs.utillinux ];

        wantedBy = [ "remote-fs-pre.target" ];
        before = [ "remote-fs-pre.target" ];
        requires = [ "basic.target" "rpcbind.service" ];
        after = [ "basic.target" "rpcbind.service" ];

        unitConfig.DefaultDependencies = false; # don't stop during shutdown

        preStart =
          ''
            mkdir -p ${nfsStateDir}/sm
            mkdir -p ${nfsStateDir}/sm.bak
            sm-notify -d
          '';

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = ''
          @${pkgs.nfs-utils}/sbin/rpc.statd rpc.statd --no-notify \
              ${if cfg.statdPort != null then "-p ${toString cfg.statdPort}" else ""}
        '';
        serviceConfig.Restart = "always";
      };

    systemd.services.idmapd =
      { description = "NFSv4 ID Mapping Daemon";

        path = [ pkgs.sysvtools pkgs.utillinux ];

        wantedBy = [ "remote-fs-pre.target" ];
        before = [ "remote-fs-pre.target" ];
        requires = [ "rpcbind.service" ];
        after = [ "rpcbind.service" ];

        preStart =
          ''
            mkdir -p ${rpcMountpoint}
            mount -t rpc_pipefs rpc_pipefs ${rpcMountpoint}
          '';

        postStop =
          ''
            umount ${rpcMountpoint}
          '';

        serviceConfig.Type = "forking";
        serviceConfig.ExecStart = "@${pkgs.nfs-utils}/sbin/rpc.idmapd rpc.idmapd -c ${idmapdConfFile}";
        serviceConfig.Restart = "always";
      };

  };
}
