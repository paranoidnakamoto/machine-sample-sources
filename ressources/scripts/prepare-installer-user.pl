#!/usr/bin/env perl
my $reponame = $ARGV[0];
my $remoteURL = $ARGV[1];

### _____________________________________________________________________________________________
### subroutines
sub executeAndDieOnFail {
    my $result = system($_[0]);
    if($result) { 
        die $result;
    }
}

sub prepareInstallerUser {  
    print "-> prepareInstallerUser\n";
    ###  Repository URL (ssh)
    print "  reponame: ".$_[0]."\n";
    ###
    print "  remoteURL: ".$_[1]."\n";
    ###
    
    my $userBase = "/root/";
    my $sshBase = $userBase."/.ssh";
    my $config = "./ssh-config";
    my $key = "./keys/".$_[0];
    my $knownHosts = "./known-hosts";

    ## Create stuff
    $command = "[ -d  $sshBase ] || mkdir $sshBase";
    executeAndDieOnFail($command);
    $command = "cp $config $sshBase/config";
    executeAndDieOnFail($command);
    $command = "cp $key $sshBase/id_git_rsa";
    executeAndDieOnFail($command);
    $command = "cp $knownHosts $sshBase/known_hosts";
    executeAndDieOnFail($command);

    ## Adjust ownership
    $command = "chown root:root $sshBase/config";
    executeAndDieOnFail($command);
    $command = "chown root:root $sshBase/id_git_rsa";
    executeAndDieOnFail($command);
    $command = "chown root:root $sshBase/known_hosts";
    executeAndDieOnFail($command);
    $command = "chown root:root $sshBase";
    executeAndDieOnFail($command);

    ##Adjust permissions
    $command = "chmod 600 $sshBase/id_git_rsa";
    executeAndDieOnFail($command);
    $command = "chmod 644 $sshBase/config";
    executeAndDieOnFail($command);
    $command = "chmod 644 $sshBase/known_hosts";
    executeAndDieOnFail($command);
    $command = "chmod 700 $sshBase";
    executeAndDieOnFail($command);

    $command = "git remote set-url origin ".$_[1];
    executeAndDieOnFail($command);

}
### _____________________________________________________________________________________________

if(!defined($reponame)) { die "reponame is not defined!";}
print $reponame."\n";
if(!defined($remoteURL)) { die "reponame is not defined!";}
print $remoteURL."\n";


prepareInstallerUser($reponame, $remoteURL);
