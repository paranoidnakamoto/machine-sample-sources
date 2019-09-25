#!/usr/bin/env perl
my $username = $ARGV[0];

### _____________________________________________________________________________________________
### subroutines
sub removeDeploymentUser {  
    print "-> removeDeploymentUser\n";
    ### reponame = username
    print "  username: ".$_[0]."\n";
    ###

    ##remove symlink
    my $command = "rm /srv/http/".$_[0];
    system($command);
    ##delete user and all files in it's home direcory
    $command = "userdel -r -f ".$_[0];
    system($command);
    #delete group
    $command = "groupdel -f ".$_[0];
    system($command);
}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";
if($username eq "lenny") { die "Lenny cannot be deleted!";}

removeDeploymentUser($username);
