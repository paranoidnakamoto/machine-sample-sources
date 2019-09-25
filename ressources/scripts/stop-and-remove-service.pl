#!/usr/bin/env perl
my $username = $ARGV[0];
my $socket = $ARGV[1];


### _____________________________________________________________________________________________
### subroutines
sub stopSocket {
    print "-> stopSocket\n";
    ### repository/username
    print "  username: ".$_[0]."\n";
    ###
    $command = "systemctl disable ".$_[0].".socket";
    system($command);

    $command = "systemctl stop ".$_[0].".socket";
    system($command);
}

sub removeSocket {
    print "-> removeSocket\n";
    ### repository/username
    print " username: ".$_[0]."\n";
    ###
    my $command = "rm /etc/systemd/system/".$_[0].".socket";
    system($command);

    $command = "rm /run/".$_[0].".sk";
    system($command);
}

sub stopService {
    print "-> stopService\n";
    ### repository/username
    print "  username: ".$_[0]."\n";
    ###
    $command = "systemctl disable ".$_[0].".service";
    system($command);

    $command = "systemctl stop ".$_[0].".service";
    system($command);
}

sub removeService {
    print "-> removeService\n";
    ### repository/username
    print " username: ".$_[0]."\n";
    ###
    my $command = "rm /etc/systemd/system/".$_[0].".service";
    system($command);
}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";

if(defined($socket)) {
    stopSocket($username);
    removeSocket($username);
}
stopService($username);
removeService($username)
