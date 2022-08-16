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
$stringHeaders = $Parser->getHeadersRaw();  // Get all headers as a string, no charset conversion
$arrayHeaders = $Parser->getHeaders();      // Get all headers as an array, with charset conversion
$text = $Parser->getMessageBody('text');
$html = $Parser->getMessageBody('html');
$htmlem = $Parser->getMessageBody('htmlEmbedded'); //HTML Body included data

#print "\n --> $from -->$to --> $subject --> $maildatex";
$from=str_replace("<","&lt;",$from);
$to=str_replace("<","&lt;",$to);
print "From : ".$from."<hr>";
print "To : ".$to."<hr>";
print "Subject : ".$subject."<hr>";
print "Date : ".$maildatex."";
$attach_dir = "/tmp/mailattach_".$message_id."_attach_tmp/";     // Be sure to include the trailing slash
#print "\n$attach_dir \n";
mkdir($attach_dir, 0777, true);
$include_inline = false ;
$Parser->saveAttachments($attach_dir,[$include_inline]);
$attachments = $Parser->getAttachments([$include_inline]);
//  Loop through all the Attachments
if (count($attachments) > 0) {
print "<hr>";
    foreach ($attachments as $attachment) {
        echo '<a href="downloadatt.php?token='.$_SESSION['token'].'&id='.$message_id.'&folder='.$attach_dir.'&filex='.$attachment->getFilename().'">'.$attachment->getFilename().' ('.filesize($attach_dir.$attachment->getFilename()).' Bytes)</a><br />';
    }
}

print "<hr>";

#if($html !=""){print "".$html."<hr>"; $donex=1;}
if($htmlem !=""){print "".$htmlem."<hr>"; $donex=1;}
if($html !="" && $donex==0){print "".$html."<hr>"; $donex=1;}
if($donex==0){print "<pre>".$text."</pre><hr>";}


// Close any open db connections
dbclose();
