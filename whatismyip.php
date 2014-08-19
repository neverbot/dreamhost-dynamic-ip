<?php

  $externalContent = file_get_contents('http://checkip.dyndns.com/');

  preg_match('/Current IP Address: ([\[\]:.[0-9a-fA-F]+)</', $externalContent, $m);

  if (array_key_exists(1, $m))
  {
    $externalIp = $m[1];
    echo $externalIp;
    return;
  }

  echo '';

?>
