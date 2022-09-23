<?php
$debugnow=0;

$powermaildbpass="aag2Eec9";
$loadbalsmtpip="192.168.30.77";
$loadbalsmtpport="25";

$filexx="/var/log/nginx/userauth.log";

$loginok=0;
$gloginuser=$_SERVER['HTTP_AUTH_USER'];
$gloginpass=$_SERVER['HTTP_AUTH_PASS'];
$glogintype=$_SERVER['HTTP_AUTH_METHOD'];
$gloginpro=$_SERVER['HTTP_AUTH_PROTOCOL'];
$gloginip=$_SERVER['HTTP_CLIENT_IP'];
$goforsql=0;
$filex=file_get_contents('user-allowed.php');
$filey=explode("\n",$filex);

file_put_contents($filexx, "LOIGNTRY : $gloginuser  : $gloginip : $gloginpro \n", FILE_APPEND);

for($e=0;$e<sizeof($filey);$e++)
{
$uchk=$filey[$e];
$uchk=str_replace("\n","",$uchk);
$uchk=str_replace("\r","",$uchk);
$uchk=str_replace("\t","",$uchk);
$uchk=str_replace("\0","",$uchk);
$uchk=str_replace(" ","",$uchk);
$uchk=str_replace("","",$uchk);
$uchk=str_replace("","",$uchk);
$uchk=str_replace("","",$uchk);
if($uchk!="")
{
$uchkm=array();
$uchkm=explode(",",$uchk);
if($debugnow==1)
{
file_put_contents($filexx, "UCHK:".$uchkm[0]." -- ".$uchkm[1]."\n", FILE_APPEND);
}

if($uchkm[0]==$gloginuser && $uchkm[1]==$gloginip){$goforsql=1;}
if($uchkm[0]==$gloginuser && $uchkm[1]=="1"){$goforsql=1;}
//////
}}

if($goforsql==1){
file_put_contents($filexx, "UCHKIPOK:$gloginuser : $gloginip \n", FILE_APPEND);

$ebdbname="powermail"; $ebdbuser="powermail"; $ebdbhost="localhost"; $ebdbpass=$powermaildbpass;
$mysqldblink = new mysqli($ebdbhost, $ebdbuser, $ebdbpass, $ebdbname);

$sqlx="SELECT `username` , `password`  FROM `mailbox` WHERE `username` = '".$gloginuser."' AND `password` = '".$gloginpass."'";

$mysqlresult = $mysqldblink->query($sqlx);
while($m1 = $mysqlresult->fetch_assoc()){
$loginok=1;
}

//go for sql --over
}


# foreach($_SERVER as $key => $value){ file_put_contents('/tmp/test.txt', "SERVER:$key:$value\n", FILE_APPEND);}


if($debugnow==1)
{
file_put_contents($filexx, "USER:$gloginuser on ".date(DATE_RFC2822)." \n", FILE_APPEND);
file_put_contents($filexx, "PASS:$gloginpass\n", FILE_APPEND);
file_put_contents($filexx, "SQLQ:$sqlx\n", FILE_APPEND);
file_put_contents($filexx, "METH:$glogintype\n", FILE_APPEND);
file_put_contents($filexx, "PROT:$gloginpro\n", FILE_APPEND);
file_put_contents($filexx, "ALLOWED:$goforsql\n", FILE_APPEND);
file_put_contents($filexx, "OK:$loginok\n\n", FILE_APPEND);
}

if($loginok==0)
{
header('Auth-Status: Invalid Login or Password or Not Allowed');
//header('Auth-Wait:1');
}
if($loginok==1){
header('Auth-User: '.$gloginuser);
header('Auth-Pass: '.$gloginpass);
header('Auth-Status: OK');
header('Auth-Method: plain');
header('Auth-Server: '.$loadbalsmtpip);
header('Auth-Port: '.$loadbalsmtpport);
}
?>

