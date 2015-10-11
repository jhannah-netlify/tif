use 5.22.0;
use DBI;
use Template;

use DBI;
my $dbh = DBI->connect("dbi:SQLite:dbname=../db/db.sqlite3");
my $strsql = <<EOT;
select tax_year, sum(total_tif_base_taxes), sum(total_tif_excess_taxes)
from year
group by tax_year
EOT
my $sth = $dbh->prepare($strsql);
$sth->execute;
while (my @row = $sth->fetchrow) {
  say join " ", @row;
}

my $tt = Template->new({
  INCLUDE_PATH => 'templates',
  INTERPOLATE  => 1,
}) || die "$Template::ERROR\n";

# https://google-developers.appspot.com/chart/interactive/docs/gallery/barchart
my $data = <<EOT;
          ['2010', 10, 24, ''],
          ['2021', 16, 22, ''],
          ['2030', 28, 19, '']
EOT

my $vars = {
  data => $data,
};

$tt->process('chart.tt2', $vars, 'www/index.html')
  || die $tt->error(), "\n";
