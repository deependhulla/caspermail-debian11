<?php
require_once "Mobile-Detect-2.8.39/Mobile_Detect.php";
$detect = new Mobile_Detect;
$mobile=0;
if ($detect->isMobile()) {$mobile=1;}
if ($detect->isTablet()) {$mobile=2;}

$myd = (array) $detect;
$jsonx = json_encode($myd,true);
$jsonx=str_replace("\u0000*\u0000","",$jsonx);
function get_client_ip() {
    $ipaddress = '';
    if (isset($_SERVER['HTTP_CLIENT_IP']))
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    else if(isset($_SERVER['HTTP_X_FORWARDED_FOR']))
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    else if(isset($_SERVER['HTTP_X_FORWARDED']))
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    else if(isset($_SERVER['HTTP_FORWARDED_FOR']))
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    else if(isset($_SERVER['HTTP_FORWARDED']))
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    else if(isset($_SERVER['REMOTE_ADDR']))
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    else
        $ipaddress = 'UNKNOWN';
    return $ipaddress;
}
$PublicIP = get_client_ip();

$sin=$_SERVER['REQUEST_URI'];

$sin=str_replace(" ","",$sin);
$sin=str_replace("|","",$sin);
$sin=str_replace(";","",$sin);
$doin=0;$dx=array();$dx=explode("/",$sin);
if(sizeof($dx)==3){$yx=array();$yx=explode("~~",$dx[2]);if(sizeof($yx)==5){$doin=1; }}
if($doin==1)
{
$dblink = mysqli_connect("localhost", "mailscanner", "zaohm8ahC2");
mysqli_select_db($dblink,"mailscanner");
$sqlx="INSERT INTO `imageviewdata` (`uid`, `msg_id`, `mail_id`, `maildatetime`,`viewdatetime`, `mobile`,`jsondeviceinfo`) VALUES (NULL, '".$yx[2]."', '".$yx[1]."', FROM_UNIXTIME('".$yx[0]."'), NOW(), '".$mobile."','".$jsonx."');";
$mysqlresult = $dblink->query($sqlx);
/////work on DB in Over
}


if(ini_get('zlib.output_compression')) { ini_set('zlib.output_compression', 'Off'); }
header('Pragma: public');   // required
header('Expires: 0');       // no cache
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Cache-Control: private',false);
header ('Content-Type: image/png');
header('Content-Transfer-Encoding: binary');
header('Content-Length: '.filesize('blank.png'));   // provide file size
readfile('blank.png');      // push it out
exit();

?>

