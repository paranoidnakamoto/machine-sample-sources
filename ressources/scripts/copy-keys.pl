#!/usr/bin/env perl
my $username = $ARGV[0];
my $reponame = $ARGV[1];

### _____________________________________________________________________________________________
### subroutines
sub executeAndDieOnFail {
    my $result = system($_[0]);
    if($result) { 
        die $result;
    }
}

sub copyKeys {  
    print "-> copyKeys\n";
    ### reponame = username
    print "  username: ".$_[0]."\n";
    ###  Repository URL (ssh)
    print "  reponame: ".$_[1]."\n";
    ###
    
    my $userBase = "/home/".$_[0];
    my $sshBase = $userBase."/.ssh";
    my $key = "./keys/".$_[1];

    my $command = "";
    ## Create stuff
    $command = "cp $key $sshBase/id_git_rsa";
    executeAndDieOnFail($command);

    ## Adjust ownership
    $command = "chown ".$_[0].":".$_[0]." $sshBase/id_git_rsa";
    executeAndDieOnFail($command);

    ##Adjust permissions
    $command = "chmod 600 $sshBase/id_git_rsa";
    executeAndDieOnFail($command);

}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";
if(!defined($reponame)) { die "reponame is not defined!";}
print $reponame."\n";

copyKeys($username, $reponame);
