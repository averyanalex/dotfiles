{
  services.kubo = {
    enable = true;
    enableGC = true;
    emptyRepo = true;

    settings.Peering.Peers = [
      {
        ID = "QmcFf2FH3CEgTNHeMRGhN7HNHU1EXAxoEk6EFuSyXCsvRE";
        Addrs = [ "/dnsaddr/node-1.ingress.cloudflare-ipfs.com" ];
      }
      {
        ID = "QmcFmLd5ySfk2WZuJ1mfSWLDjdmHZq7rSAua4GoeSQfs1z";
        Addrs = [ "/dnsaddr/node-2.ingress.cloudflare-ipfs.com" ];
      }
      {
        ID = "QmcfFmzSDVbwexQ9Au2pt5YEXHK5xajwgaU6PpkbLWerMa";
        Addrs = [ "/dnsaddr/node-3.ingress.cloudflare-ipfs.com" ];
      }
      {
        ID = "QmcfJeB3Js1FG7T8YaZATEiaHqNKVdQfybYYkbT1knUswx";
        Addrs = [ "/dnsaddr/node-4.ingress.cloudflare-ipfs.com" ];
      }
      {
        ID = "12D3KooWCVXs8P7iq6ao4XhfAmKWrEeuKFWCJgqe9jGDMTqHYBjw";
        Addrs = [ "/ip4/139.178.68.217/tcp/6744" ];
      }
      {
        ID = "12D3KooWGBWx9gyUFTVQcKMTenQMSyE2ad9m7c9fpjS4NMjoDien";
        Addrs = [ "/ip4/147.75.49.71/tcp/6745" ];
      }
      {
        ID = "12D3KooWKd92H37a8gCDZPDAAGTYvEGAq7CNk1TcaCkcZedkTwFG";
        Addrs = [ "/ip4/147.75.85.47/tcp/4001" ];
      }
      {
        ID = "12D3KooWJ59N9z5CyLTtcUTnuTKnRTEVxiztijiEAYbP16aZjQ3D";
        Addrs = [ "/ip4/147.75.84.155/tcp/4001" ];
      }
      {
        ID = "12D3KooWLsSWaRsoCejZ6RMsGqdftpKbohczNqs3jvNfPgRwrMp2";
        Addrs = [ "/ip4/147.75.81.81" ];
      }
      {
        ID = "12D3KooWJc7GbwkjVg9voPNxdRnmEDS3i8NXNwRXD6kLattaMnE4";
        Addrs = [ "/ip4/147.75.101.41/tcp/4001" ];
      }
      {
        ID = "QmUEMvxS2e7iDrereVYc5SWPauXPyNwxcy9BXZrC1QTcHE";
        Addrs = [ "/dns/cluster0.fsn.dwebops.pub" ];
      }
      {
        ID = "QmNSYxZAiJHeLdkBg38roksAR9So7Y5eojks1yjEcUtZ7i";
        Addrs = [ "/dns/cluster1.fsn.dwebops.pub" ];
      }
      {
        ID = "12D3KooWFFhc8fPYnQXdWBCowxSV21EFYin3rU27p3NVgSMjN41k";
        Addrs = [ "/ip4/5.161.92.43/tcp/4001" "/ip6/2a01:4ff:f0:3b1e::1/tcp/4001" ];
      }
      {
        ID = "12D3KooWSW4hoHmDXmY5rW7nCi9XmGTy3foFt72u86jNP53LTNBJ";
        Addrs = [ "/ip4/5.161.55.227/tcp/4001" "/ip6/2a01:4ff:f0:1e5a::1/tcp/4001" ];
      }
      {
        ID = "12D3KooWPySxxWQjBgX9Jp6uAHQfVmdq8HG1gVvS1fRawHNSrmqW";
        Addrs = [ "/ip4/147.75.33.191/tcp/4001" ];
      }
      {
        ID = "12D3KooWQYBPcvxFnnWzPGEx6JuBnrbF1FZq4jTahczuG2teEk1m";
        Addrs = [ "/ip4/147.75.80.9/tcp/4001" ];
      }
      {
        ID = "12D3KooWEzCun34s9qpYEnKkG6epx2Ts9oVGRGnzCvM2s2edioLA";
        Addrs = [ "/ip4/147.75.80.143/tcp/4001" ];
      }
      {
        ID = "12D3KooWQE3CWA3MJ1YhrYNP8EE3JErGbrCtpKRkFrWgi45nYAMn";
        Addrs = [ "/ip4/147.75.84.119/tcp/4001" ];
      }
      {
        ID = "12D3KooWDYVuVFGb9Yj6Gi9jWwSLqdnzZgqJg1a1scQMDc4R6RUJ";
        Addrs = [ "/ip4/147.75.84.175/tcp/4001" ];
      }
      {
        ID = "12D3KooWSafoW6yrSL7waghFAaiCqGy5mdjpQx4jn4CRNqbG7eqG";
        Addrs = [ "/ip4/147.75.84.173/tcp/4001" ];
      }
      {
        ID = "12D3KooWJEfH2MB4RsUoaJPogDPRWbFTi8iehsxsqrQpiJwFNDrP";
        Addrs = [ "/ip4/136.144.57.15/tcp/4001" ];
      }
      {
        ID = "12D3KooWHpE5KiQTkqbn8KbU88ZxwJxYJFaqP4mp9Z9bhNPhym9V";
        Addrs = [ "/ip4/147.75.63.131/tcp/4001" ];
      }
    ];
  };
}
