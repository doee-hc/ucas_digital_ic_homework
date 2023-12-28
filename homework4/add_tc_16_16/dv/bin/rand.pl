#!/usr/bin/perl
my $trand = &myrand();
print ("$trand");
sub myrand {
  #return date munge instead of real rand
  (my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdst) = localtime(time);
  $mon = $mon + 1;
  $year = ($year + 1900) % 100;
  my $rv = sprintf("%.2d%.2d%.2d%.2d%.2d",$mon+$year,$mday,$hour,$min,$sec);#use month+year to fit 32bit
  srand($rv);
  $rv=int(rand(4294967295));
  #sleep 1; #make sure the next "myrand" returns a diff value
  return $rv;
}
