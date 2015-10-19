<?php
    class fileWriter {
        public function __construct() {
            print "Useless Constructor\n";
        }
        public function process($listid, $listname, $listcontent) {
            $file = 'people.txt';
            // Write the contents back to the file
            //print $listid . " " . $listname . " " . $listcontent . "\n";
            file_put_contents($file, $listid . " " . $listname . " " . $listcontent . "\n", FILE_APPEND | LOCK_EX);
        }
    }

$shortopts = "i:n:c:";
$params = getopt($shortopts);
//var_dump($params);
$listid = trim($params["i"]);
$listname = trim($params["n"]);
$contents = trim($params["c"]);
print $listid . " " . $listname . " " . $contents . "\n";
$mywriter = new fileWriter();
$mywriter->process($listid, $listname, $contents);
?>
