#!/usr/bin/perl
use utf8;
binmode(STDOUT, ":utf8");
use File::Path;
use Data::Dumper;
use Text::Table;

# //////////////////////////////// GUIDE ////////////////////////////////

# First, you need to download Text::Table, File::Path, Data::Dumper modules. 
# On UNIX, type this command to install required modules: sudo cpan install Module::Name

# Conf file is generated automatically when you create DB. So, you don't need to give path in every command.
# Conf file is located at where perl script is stored.

# Example commands you can use :

# Create DB = perl proje.pl Create DB mydb1 /Users/macbook/Desktop/Scripting\ Languages

# Create Table = perl proje.pl Create Table --in mydb1 mytable --columns --primary-key id ad soyad

# Delete DB = perl proje.pl Delete DB mydb1

# Delete Table = perl proje.pl Delete Table --in mydb1 mytable

# Insert Into = perl proje.pl Insert Into --in mydb1 mytable id 1 ad talha soyad kum

# Select Table = perl proje.pl Select Table --in mydb1 mytable 

# Update Table = perl proje.pl Update Table --in mydb1 mytable datekin dağtekin

# Warning: Don't put / (Slash) at the end of the path when writing commands
# Example: Create DB mydb1 /Users/macbook/Desktop/Scripting\ Languages

# ////////////////////////////////////////////////////////////////////////

# It stores number of arguments
$sum_of_params=@ARGV;

# Checks if arguments match with commands  (case-insensitive)
if( uc($ARGV[0]) eq "CREATE" && uc($ARGV[1]) eq "DB") {

    # Generate file path by using arguments
    my $directory=$ARGV[3]."/".$ARGV[2];

    # Make directory (database). Die if can't create it
    if(mkdir $directory) {
        print "Database created!\n";
    }
    else {
        die "Unable to create database!\n";
    }

    # get reference of existing databases hash
    my %existingDatabase;

    # Conf file exists, so read first then write into new database location
    if(-e "conf.txt") {
        unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $str variable
    # Because it is dumper format, we must decode it.
    local($/) = "";
    my($str) = <FILE>;

    my($Databases);
    eval $str;
    (%existingDatabase) = %$Databases;

    }
    
        # Open Conf file to write, Create if doesn't exist
        # Append database locations to conf.txt
        unless(open CONFFILE, '>'.'conf.txt') {
        # Die with error message 
        # if can't create conf file.
        die "\nUnable to create conf file!\n";
        }

        my %newHash;
        # Put database name to conf file as key
        $newHash{$ARGV[2]}=$directory;

        # Add hash to new added database and it's location
        my %hash=(%existingDatabase, %newHash);

        my $databases = Data::Dumper->Dump([ \%hash ], ['$Databases']);

       print CONFFILE $databases;
       close CONFFILE;  
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "CREATE" && uc($ARGV[1]) eq "TABLE") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $str variable
    # Because it is dumper format, we must decode it.
    local($/) = "";
    my($str) = <FILE>;

    my($Databases);
    eval $str;
    my(%hash) = %$Databases;
    
    # Get database location from conf file and add it to location array.
    my @location= @{[$hash{$ARGV[3]}]};
    close FILE;

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to create table because there isn't such a database!\n";
    }

    my $file = $location[0]."/".$ARGV[4].".txt";

    # Check if table file is exist
    if(-e $file) {
        die "\nAlready there is a table: $ARGV[4]!\n";
    }

    # open file to create the table.
    unless(open FILE, '>'.$file) {
        # Die with error message 
        # if can't create table.
        die "\nUnable to create table!\n";
    }
    else {
        print "Table created!\n";
    }

    my @args;

    # Add columns to the args array.
    for(my $i=7; $i<=$sum_of_params; $i++) {
         push @args, $ARGV[$i];
    }

    # Put args array to the new table.
    # Thus, columns are added to table.
    my $tb = Text::Table->new(@args);

    # Write new table variable($tb) to table file.
    print FILE $tb;

    close FILE;
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "DELETE" && uc($ARGV[1]) eq "DB") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $str variable
    # Because it is dumper format, we must decode it.
    local($/) = "";
    my($str) = <FILE>;

    my($Databases);
    eval $str;
    my(%hash) = %$Databases;
    
    my @location= @{[$hash{$ARGV[2]}]};

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to delete database because there isn't such a database!\n";
    }

    my $dir = "$location[0]";

    # Remove database
    rmtree $dir;

    # Check if database is exist
    if(-e $dir) 
    {
        print "Database '$ARGV[2]' couldn't be deleted!\n";
    }
    else 
    {
        print "Database '$ARGV[2]' deleted.\n";
    }

    close FILE;

    # delete given database from hash
    delete $hash{$ARGV[2]};

    # Open Conf file to delete
    # Delete database and locations from conf.txt
    unless(open CONFFILE, '>'.'conf.txt') {
    # Die with error message 
    # if can't open conf file.
        die "\nUnable to delete database from conf file!\n";
    }

    my $databases = Data::Dumper->Dump([ \%hash ], ['$Databases']);

    print CONFFILE $databases;
    close CONFFILE; 
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "DELETE" && uc($ARGV[1]) eq "TABLE") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $str variable
    # Because it is dumper format, we must decode it.
    local($/) = "";
    my($str) = <FILE>;

    my($Databases);
    eval $str;
    my(%hash) = %$Databases;
    
    my @location= @{[$hash{$ARGV[3]}]};

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to delete table because there isn't such a database!\n";
    }

    my $dir=$location[0]."/".$ARGV[4].".txt";

    # Delete table file
    unlink $dir;

    # Check if file exists
    if(-e $dir) {
        print "Table '$ARGV[4]' couldn't be deleted!\n";
    }
    else {
        print "Table '$ARGV[4]' deleted!\n";
    }

    close FILE;
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "INSERT" && uc($ARGV[1]) eq "INTO") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $vars variable
    # Because it is dumper format, we must decode it.
    my $vars;
    { local $/ = undef; $vars = <FILE>; }

    my($Databases);
    eval $vars;
    my(%hash) = %$Databases;
    
    my @location= @{[$hash{$ARGV[3]}]};
    close FILE;

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to insert because there isn't such a database!\n";
    }

    my $file = $location[0]."/".$ARGV[4].".txt";

    unless(-e $file) {
        die "\nUnable to insert because there is no such a table!\n";
    }

    # Read table txt file to get table content
    unless(open FILE, '<'.$file) {
        # Die with error message 
        # if can't open table.
        die "\nUnable to open table!\n";
        }

    # Get all table content to array. It will be used later. (while inserting row)
    @tableContent=<FILE>;

    close FILE;

    # Open table to insert new row
    unless(open FILE, '>'.$file) {
        # Die with error message 
        # if can't open table.
        die "\nUnable to open table!\n";
        }

    my @data;

    # Iterate args pair <COLUMN> <DATA>
    for(my $i=5; $i<=$sum_of_params; $i+=2) {
        push @data, $ARGV[$i+1];
    }

    # Create table Text::Table variable to get all data from table
    # And add new row to it
    my $table=Text::Table->new();

    # Get all data to table
    $table->load(@tableContent);

    # Add new row to table
    $table->add(@data);

    # Print table to table file.
    print FILE $table;

    close FILE;
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "SELECT" && uc($ARGV[1]) eq "TABLE") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $vars variable
    # Because it is dumper format, we must decode it.
    my $vars;
    { local $/ = undef; $vars = <FILE>; }

    my($Databases);
    eval $vars;
    my(%hash) = %$Databases;
    
    my @location= @{[$hash{$ARGV[3]}]};
    close FILE;

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to select because there isn't such a database!\n";
    }

    my $file = $location[0]."/".$ARGV[4].".txt";

    unless(-e $file) {
        die "\nUnable to select because there is no such a table!\n";
    }

    # Read table txt file to get table content
    # Use encoding UTF-8 to get table content with utf8 support
    unless(open FILE, '<:encoding(UTF-8)',$file) {
        # Die with error message 
        # if can't open table.
        die "\nUnable to open table!\n";
        }

    # Get all table content to array. It will be used later. (while inserting row)
    @tableContent=<FILE>;

    close FILE;

    # Create table Text::Table variable to get all data from table
    my $table=Text::Table->new();

    # Get all data to table
    $table->load(@tableContent);

    # Print table to user
    print "$table";
}

# Checks if arguments match with commands  (case-insensitive)
if(uc($ARGV[0]) eq "UPDATE" && uc($ARGV[1]) eq "TABLE") {

    # Read conf.txt to find out where database is located
    unless(open FILE, '<'."conf.txt") {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    # Get file content to $vars variable
    # Because it is dumper format, we must decode it.
    my $vars;
    { local $/ = undef; $vars = <FILE>; }

    my($Databases);
    eval $vars;
    my(%hash) = %$Databases;
    
    my @location= @{[$hash{$ARGV[3]}]};
    close FILE;

    # Check if is there a such database in conf.txt
    if(!$location[0]) {
        die "Unable to update because there isn't such a database!\n";
    }

    my $file = $location[0]."/".$ARGV[4].".txt";

    unless(-e $file) {
        die "\nUnable to update because there is no such a table!\n";
    }

    # Read table txt file to get table content
    unless(open FILE, '<'.$file) {
        # Die with error message 
        # if can't open table.
        die "\nUnable to open table!\n";
        }

    # Get all table content to array. It will be used later. (while inserting row)
    @tableContent=<FILE>;

    close FILE;

    # First, find given string and change it with given arguments by using regular expression
    my @newlines;
    foreach(@tableContent) {
        $_ =~ s/$ARGV[5]/$ARGV[6]/gi;
        push(@newlines,$_);
    }

    # Open file to write updates 
    unless(open FILE, '>'.$file) {
        # Die with error message 
        # if can't read conf file.
        die "\nUnable to read conf file!\n";
        }

    print 
    print FILE @newlines;

    close FILE;
}
