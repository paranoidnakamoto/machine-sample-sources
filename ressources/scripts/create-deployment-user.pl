#!/usr/bin/env perl
my $username = $ARGV[0];
my $reponame = $ARGV[1];
my $repositoryurl = $ARGV[2];
my $branch = $ARGV[3];

### _____________________________________________________________________________________________
### subroutines
sub executeAndDieOnFail {
    my $result = system($_[0]);
    if($result) { 
        die $result;
    }
}

sub prepareDeploymentUser {  
    print "-> prepareDeploymentUser\n";
    ### reponame = username
    print "  username: ".$_[0]."\n";
    ###  Repository URL (ssh)
    print "  reponame: ".$_[1]."\n";
    ###
    print "  repositoryurl: ".$_[2]."\n";
    ###
    print "  branch: ".$_[3]."\n";
    ###
    
    my $userBase = "/home/".$_[0];
    my $sshBase = $userBase."/.ssh";
    my $config = "./ssh-config";
    my $key = "./keys/".$_[1];
    my $knownHosts = "./known-hosts";

    ## Create stuff
    my $command = "getent group ".$_[0]." || groupadd ".$_[0];
    executeAndDieOnFail($command);
    $command = "id -u ".$_[0]." >/dev/null 2>&1 || useradd -m -g ".$_[0]." -s /bin/bash ".$_[0];
    executeAndDieOnFail($command);
    $command = "[ -d  $sshBase ] || mkdir $sshBase";
    executeAndDieOnFail($command);
    $command = "cp $config $sshBase/config";
    executeAndDieOnFail($command);
    $command = "cp $key $sshBase/id_git_rsa";
    executeAndDieOnFail($command);
    $command = "cp $knownHosts $sshBase/known_hosts";
    executeAndDieOnFail($command);

    ## Adjust ownership
    $command = "chown ".$_[0].":".$_[0]." $sshBase/config";
    executeAndDieOnFail($command);
    $command = "chown ".$_[0].":".$_[0]." $sshBase/id_git_rsa";
    executeAndDieOnFail($command);
    $command = "chown ".$_[0].":".$_[0]." $sshBase/known_hosts";
    executeAndDieOnFail($command);
    $command = "chown ".$_[0].":".$_[0]." $sshBase";
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

    ## clone deployment from repo
    my $cloneCommand = "git clone --single-branch --branch ".$_[3]." ".$_[2];
    $command = "[ -d  $userBase/".$_[1]." ] || sudo -u ".$_[0]." -H sh -c 'cd $userBase; $cloneCommand;'";
    executeAndDieOnFail($command);
}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";
if(!defined($reponame)) { die "reponame is not defined!";}
print $reponame."\n";
if(!defined($repositoryurl)) { die "repositoryurl is not defined!";}
print $repositoryurl."\n";
if(!defined($branch)) { die "branch is not defined!";}
print $branch."\n";


prepareDeploymentUser($username, $reponame, $repositoryurl, $branch);
