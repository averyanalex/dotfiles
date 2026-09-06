{ pkgs }:

pkgs.runCommand "bambu-printer-ca-bundle"
  {
    nativeBuildInputs = with pkgs; [
      coreutils
      gnugrep
      openssl
    ];
  }
  ''
    test "$(grep -c -- '-----BEGIN CERTIFICATE-----' ${./bambu-printer-ca-bundle.cer})" -eq 5
    test "$(grep -c -- '-----BEGIN CERTIFICATE-----' ${./bambuddy-virtual-printer-ca.crt})" -eq 1

    identity="$(openssl x509 -in ${./bambuddy-virtual-printer-ca.crt} -noout -subject -issuer -nameopt RFC2253)"
    test "$identity" = $'subject=CN=Virtual Printer CA\nissuer=CN=Virtual Printer CA'
    openssl x509 -in ${./bambuddy-virtual-printer-ca.crt} -noout -checkend 0

    install -Dm0644 ${./bambu-printer-ca-bundle.cer} "$out/share/bambu-certs/printer.cer"
    printf '\n' >> "$out/share/bambu-certs/printer.cer"
    cat ${./bambuddy-virtual-printer-ca.crt} >> "$out/share/bambu-certs/printer.cer"

    test "$(grep -c -- '-----BEGIN CERTIFICATE-----' "$out/share/bambu-certs/printer.cer")" -eq 6
    openssl crl2pkcs7 -nocrl -certfile "$out/share/bambu-certs/printer.cer" >/dev/null
    openssl verify -CAfile "$out/share/bambu-certs/printer.cer" ${./bambuddy-virtual-printer-ca.crt}
  ''
