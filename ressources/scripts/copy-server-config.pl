#!/usr/bin/env perl
my $username = $ARGV[0];

### _____________________________________________________________________________________________
### subroutines
sub executeAndDieOnFail {
    my $result = system($_[0]);
    if($result) { die $result;}  
    if($result) { die "error on: ".$_[0];}  
}

sub copyServerConfig {
    print "-> copyServerConfig\n";
    ### repository/username
    print " username: ".$_[0]."\n";
    ###

    my $basePath = "/etc/nginx/servers";
    ## assert that the base folder exists
    my $command = "[ -d $basePath ] || mkdir -p  $basePath";
    executeAndDieOnFail($command);

    $command = "cp nginx-files/".$_[0]." $basePath/";
    executeAndDieOnFail($command);
}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";

copyServerConfig($username);

