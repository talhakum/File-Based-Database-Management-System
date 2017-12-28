# File-Based-Database-Management-System

## Scripting Languages course project with Perl. 

First, you need to download Text::Table, File::Path, Data::Dumper modules. 
On UNIX, type this command to install required modules: sudo cpan install Module::Name

Conf file is generated automatically when you create DB. So, you don't need to give path in every command.
Conf file is located at where perl script is stored.

Example commands you can use :

Create DB = perl proje.pl Create DB mydb1 /Users/macbook/Desktop/Scripting\ Languages

Create Table = perl proje.pl Create Table --in mydb1 mytable --columns --primary-key id ad soyad

Delete DB = perl proje.pl Delete DB mydb1

Delete Table = perl proje.pl Delete Table --in mydb1 mytable

Insert Into = perl proje.pl Insert Into --in mydb1 mytable id 1 ad talha soyad kum

Select Table = perl proje.pl Select Table --in mydb1 mytable 

Update Table = perl proje.pl Update Table --in mydb1 mytable datekin dağtekin

Warning: Don't put / (Slash) at the end of the path when writing commands
Example: Create DB mydb1 /Users/macbook/Desktop/Scripting\ Languages

See details of the project: https://drive.google.com/open?id=1KiywlZD2Q2yAR_LvXZ_W1V7tCNewOb7j
