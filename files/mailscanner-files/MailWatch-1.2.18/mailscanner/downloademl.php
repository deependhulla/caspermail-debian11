<?php
require_once __DIR__ . '/functions.php';
require_once __DIR__ . '/lib/pear/Mail/mimeDecode.php';
ini_set('memory_limit', MEMORY_LIMIT);
require __DIR__ . '/login.function.php';
dbconn();
if (!isset($_GET['id']) && !isset($_GET['amp;id'])) {
    die(__('nomessid06'));
}
if (isset($_GET['amp;id'])) {
    $message_id = deepSanitizeInput($_GET['amp;id'], 'url');
} else {
    $message_id = deepSanitizeInput($_GET['id'], 'url');
}
if (!validateInput($message_id, 'msgid')) {
    die();
}

$sqlx='SELECT `id`,`maillog_id`, `timestamp`, `size`, `from_address`, `from_domain`, `to_address`, `to_domain`, `subject`, `clientip`, `archive`, `isspam`, `ishighspam`, `issaspam`, `isrblspam`, `isfp`, `isfn`, `spamwhitelisted`, `spamblacklisted`, `sascore`, `spamreport`, `virusinfected`, `nameinfected`, `otherinfected`, `report`, `ismcp`, `ishighmcp`, `issamcp`, `mcpwhitelisted`, `mcpblacklisted`, `mcpsascore`, `mcpreport`, `hostname`, `date`, `time`, `headers`, `messageid`, `quarantined`, `rblspamreport`, `token`, `released`, `salearn`, `last_update` FROM `maillog` WHERE `id` = \''.$message_id.'\' limit 0,1';

#print $sqlx;
$mysqlresult = dbquery($sqlx);
$rtotal=0;

while($row = $mysqlresult->fetch_array()){
$dvdvalue=$row['archive'];
$dvddate="";
$dvddatex=array();
$dvddatex=explode(" ",$row['timestamp']);
$dvddate=$dvddatex[0];
$dvddate=str_replace("-","",$dvddate);
$dvdfile=$row['id'];
$dvdvalue=$dvdvalue.$dvddate."/".$dvdfile;
}
#print "dddd ".time()."\n";
#print "<hr> $dvdvalue  <hr>\n";

$mailfile=$dvdvalue;
$mc=array();
$mc1=file_get_contents($mailfile);
$mc=explode("\n",$mc1);
$maildata="";
$d=0;
$d1=0;
for($e=0;$e<sizeof($mc);$e++)
{
$l=array();
$l=explode("<",$mc[$e]);
if($l[0] !="O" && $l[0] !="S"){$d=1;}
if($d==1){
if($d1!=0){$maildata=$maildata."\n";}
$maildata=$maildata.$mc[$e];
$d1++;
}
}

#print "<hr> <pre>".$maildata;

require_once 'vendor/autoload.php';
$Parser = new PhpMimeMailParser\Parser();
$Parser->settext($maildata);

echo $Parser->getRawHeader('diagnostic-code');

$to = $Parser->getHeader('to');
$from = $Parser->getHeader('from');
$subject = $Parser->getHeader('subject');
$maildatex = $Parser->getHeader('date');


// Close any open db connections
$filey="EML ".$subject."- EMail.eml";
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'.$filey.'"');
#     header('Content-Disposition: attachment; filename="downloaded.pdf"');
#    readfile($gfile);
echo $maildata;
dbclose();
    exit;

