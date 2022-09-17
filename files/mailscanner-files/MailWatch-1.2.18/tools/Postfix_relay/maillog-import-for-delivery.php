<?php

error_reporting (E_ERROR);

#ini_set('error_log', 'syslog');
#ini_set('html_errors', 'off');
#ini_set('display_errors', 'on');
#ini_set('implicit_flush', 'false');
set_time_limit(0);
include_once('/var/www/html/mailscanner/conf.php');
$dlog='/var/log/mail.log';
$ebdbuser=DB_USER;
$ebdbpass=DB_PASS;
$ebdbhost=DB_HOST;
$ebdbname=DB_NAME;

$dblink = mysqli_connect("$ebdbhost", "$ebdbuser", "$ebdbpass") or die("Could not connect MySQL  check user/pass/host\n");
mysqli_select_db($dblink,$ebdbname) or die("Could : not select database $ebdbname \n");


$gotrecord=0;

function dolog($input)
{
global $fp;
global $gotrecord;
global $logbreaktype;
global $mon;
global $dblink;
    if (!$fp = popen($input, 'r')) {
        die(__('diepipe54'));
    }

    $lines = 1;
$l=0;
    while ($line = fgets($fp, 2096)) {
////// while loop start
$gotrecord=0;
$mline=array();$mline=explode(" ",$line);
$mlinedata="";
$ee=0;
for($e=3;$e<sizeof($mline);$e++)
{
if($ee!=0){$mlinedata=$mlinedata." ";}
$ee++;
$mlinedata=$mlinedata.$mline[$e];

}
$mline1=array();$mline1=explode("T",$mline[0]);
$mline2=array();$mline2=explode(".",$mline1[1]);
$mline3=array();$mline3=explode("[",$mline[2]);
$mline4=array();$mline4=explode("]",$mline3[1]);
#print "\nReading $l"; 
$l++;
$msgid1="";
$msgid2="";
$msgid="";
$efrom="";
$eto="";
$esubject="";
$logx=array();
$logfirstpart="";
$logx['logdate']="";
$logx['logtime']="";
$logx['logtimenano']="";
$logx['loghost']="";
$logx['logname']="";
$logx['logpid']="";
$logx['logmsg']="";
#print $line;


$logx['logdate']=$mline1[0];
$logx['logtime']=$mline2[0];
$logx['logtimenano']=trim($mline2[1]);
$logx['loghost']=$mline[1];
$logx['logname']=$mline3[0];
$logx['logpid']=$mline4[0];
$logx['logmsg']=trim($mlinedata);

###########################################################################
######### Reading and breaking line Array for process with Date-time With TimeZone  
###########################################################################
$gotrecord=0;
#print_r($logx);
############################################
if($logx['logname']=='postfix/smtp' || $logx['logname']=='postfix/pipe')
{
#print_r($logx);
$datax=array();
$datax=explode(":",$logx['logmsg']);
$datax1=explode(" ",$datax[0]);
$dsize1=sizeof($datax1);
if($dsize1==1)
{
$datay=array();
$datay=explode(" ",$logx['logmsg']);
$msg_id=$datax[0];
$gotrecord=1;
#print_r($logx);
$data2=array();
$data2=explode(", ",$datax[1]);
#print_r($datay);
$to_address=trim($data2[0]);
$to_address=str_replace("to=<","",$to_address);
$to_address=str_replace(">","",$to_address);
$relay_to=trim($datay[2]);
$relay_to=str_replace("relay=","",$relay_to);
$relay_to=str_replace(",","",$relay_to);
$delay=trim($datay[3]);
$delay=str_replace("delay=","",$delay);
$delay=str_replace(",","",$delay);
$dsn=trim($datay[5]);
$dsn=str_replace("dsn=","",$dsn);
$dsn=str_replace(",","",$dsn);
$status_code=trim($datay[6]);
$status_code=str_replace("status=","",$status_code);
$status_code=str_replace(",","",$status_code);
$sx="";
$ss=0;
for($s=7;$s<sizeof($datay);$s++)
{
if($ss!=0){$sx=$sx." ";}
$ss++;
$sx=$sx.$datay[$s];
}
$status_text=trim($sx);

///dsize==1 over
}
/////logname -over
}
###########################################################################
##########Work on Insert started #################################################################
if($gotrecord==1)
{

$status_text1=$dblink->real_escape_string($status_text);
$relay_to1=$dblink->real_escape_string($relay_to);

if(!is_numeric($delay))
 {
 $delay=0;
 }


$sqlx="REPLACE INTO mtalog (`relay_date`,`relay_time`,`host`,`status_code`,`msg_id`,`to_address`,`relay_to`,`dsn`,`status_text`,`delay`) VALUES ('".$logx['logdate']."','".$logx['logtime']."','".$logx['loghost']."','".$status_code."','".$msg_id."','".$to_address."','".$relay_to1."','".$dsn."','".$status_text1."',SEC_TO_TIME('".$delay."'))";
print "\n --> $sqlx \n";

$upqueryresult = $dblink->query($sqlx);
if (!$upqueryresult)
{
print "\n Error for $sqlx \n ".mysqli_error($dblink)." \n";
exit;
}

}
###########Work on insert over ################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
##### Work for sasl User auth info to get ########################################################
$gotrecord=0;
$getsaslauthuser="";
$getsaslmailid="";
$getauthtype="";
############################################
if($logx['logname']=='postfix/smtpd' || $logx['logname']=='postfix/submission/smtpd')
{
#print_r($logx);
$datax=array();
$datax=explode(":",$logx['logmsg']);
$datax1=explode(" ",$datax[0]);
#print "\n---\n"; 
#print_r($datax1);
if(sizeof($datax1)==1)
{
$datax2=array();
$datax2=explode(" ",$logx['logmsg']);
if(sizeof($datax2)==4)
{
$datax3=array();
$datax3=explode("=",$datax2[3]);
if($datax3[0]=="sasl_username")
{
#print_r($logx);
#print "\n---\n"; 
#print_r($datax1);
#print "\n---\n"; 
#print_r($datax2);
#print_r($datax3);
#print "\nXXXXXXXXX\n";
$gotrecord=1;
$getsaslauthuser=$datax3[1];
$getsaslmailid=$datax1[0];
$getauthtype='465';
if($logx['logname']=='postfix/submission/smtpd')
{
$getauthtype='587';
}
#print "\n --> $getsaslauthuser--> $getsaslmailid --> $getauthtype --> \n";

}
}
}


}
/////logname -over
###########################################################################
##########Work on Insert started #################################################################
if($gotrecord==1)
{

$status_text1=$dblink->real_escape_string($status_text);
$relay_to1=$dblink->real_escape_string($relay_to);

$sqlx="REPLACE INTO maillog_auth (`mail_id`,`auth_type`,`clientauth`) VALUES ('".$getsaslmailid."','".$getauthtype."','".$getsaslauthuser."')";
print "\n --> $sqlx \n";
$upqueryresult = $dblink->query($sqlx);
if (!$upqueryresult)
{
print "\n Error for $sqlx \n ".mysqli_error($dblink)." \n";
exit;
}

}
###########Work on insert over ################################################################
##### Work for sasl User auth info to get ########################################################
###########################################################################


### work for Caser ID for mapping --start
$gotrecord=0;
$smtpd_id="";
$smtp_id="";
if($logx['logname']=='postfix/cleanup')
{
#print_r($logx);
$datax=array();
$datax=explode(":",$logx['logmsg']);
$datax1=explode(" ",$datax[0]);
#print "\n---\n"; 
#print_r($datax);
$headerbox=$datax[2];
$headerbox=str_replace(" ","",$headerbox);
if($headerbox=="headerX-CASPER-MailScanner-ID")
{
#print "\n---------------\n";
#print_r($datax);
$datax3=array();
$datax3=explode(" ",$datax[3]);
#print_r($datax3);

$smtp_id=$datax[0];
$smtpd_id=$datax3[1];
$gotrecord=1;
}

##########Work on Insert started #################################################################
if($gotrecord==1)
{
 
$status_text1=$dblink->real_escape_string($status_text);
$relay_to1=$dblink->real_escape_string($relay_to);

$sqlx="REPLACE INTO mtalog_ids (`smtpd_id`,`smtp_id`) VALUES ('".$smtpd_id."','".$smtp_id."')";
print "\n --> $sqlx \n";
$upqueryresult = $dblink->query($sqlx);
if (!$upqueryresult)
{
print "\n Error for $sqlx \n ".mysqli_error($dblink)." \n";
exit;
}

}
###########Work on insert over ################################################################


}
### work for Caser ID for mapping --end
###########################################################################
###########################################################################
###########################################################################
###########################################################################
###########################################################################
////////// while loop over
}
        $lines++;
    pclose($fp);
}
/////////////////////////////
if (isset($_SERVER['argv'][1]) && $_SERVER['argv'][1] === '--do-one-time') {
    dolog('cat ' . $dlog);
} else {
    // Refresh first time log file
    dolog('cat ' . $dlog);
    // Start watching with tail
    dolog('tail -F -n0 ' . $dlog);
}
/////////////////////////////
