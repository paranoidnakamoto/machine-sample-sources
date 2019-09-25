#!/usr/bin/perl
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

sub createSymlinkForNginx {  
    print "-> createSymlinkForNginx\n";
    ### reponame = username
    print "  username: ".$_[0]."\n";
    ###  Repository URL (ssh)#
    print "  reponame: ".$_[1]."\n";
    ###
    
    my $pathBase = "/home/".$_[0];
    my $linkBase = "/srv/http";

    my $websiteBasePath = $pathBase."/$reponame";
    my $websiteBaseLink = $linkBase."/$username";

    my $command = "mkdir -p $linkBase";
    executeAndDieOnFail($command);
    $command = "ln -sfn $websiteBasePath $websiteBaseLink";
    executeAndDieOnFail($command);

    # my $result = symlink($websiteBasePath, $websiteBaseLink);
    # if($result) {die $result;}
    ##
    $command = "chmod a+X $pathBase";
    executeAndDieOnFail($command);
}
### _____________________________________________________________________________________________

if(!defined($username)) { die "username is not defined!";}
print $username."\n";
if(!defined($reponame)) { die "reponame is not defined!";}
print $reponame."\n";

createSymlinkForNginx($username, $reponame);
