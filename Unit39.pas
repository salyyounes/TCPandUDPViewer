unit Unit39;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.ImgList,shellapi;

type
  TForm39 = class(TForm)
    StatusBar1: TStatusBar;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Refresh1: TMenuItem;
    ImageList1: TImageList;
    CheckonRIPEDB1: TMenuItem;
    ImageList2: TImageList;
    SaveListtoTextFile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure Refresh1Click(Sender: TObject);
    procedure CheckonRIPEDB1Click(Sender: TObject);
    procedure SaveListtoTextFile1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form39: TForm39;

implementation

uses activeconnections,madcrypt;

{$R *.dfm}


function Split(TempString,Delimiter : String; StrIndex : Integer) : String;
var
CurrIndex : Integer ;
begin
TempString:=TempString + Delimiter;
if Pos(Delimiter,TempString)<>0
  then
   begin
    CurrIndex:=1;
    while StrIndex>CurrIndex
     do
      begin
       TempString:=Copy( TempString,
                         Pos(Delimiter,TempString)+Length(Delimiter),
                         MaxInt
                       );
       Inc(CurrIndex);
      end;
    Result:=Copy(TempString,0,Pos(Delimiter,TempString)-1);
   end;
end;

procedure TForm39.CheckonRIPEDB1Click(Sender: TObject);
begin
if listview1.Selected = nil then exit;


 ShellExecute(Handle, 'open', pchar('https://apps.db.ripe.net/search/query.html?searchtext='+listview1.Selected.SubItems[3]),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm39.FormCreate(Sender: TObject);
begin
form39.Caption:='TCP & UDP Viewer by Salyyounes@mail.com';
end;

procedure TForm39.Refresh1Click(Sender: TObject);
var
strlist:Tstringlist;
i:integer;
str:string;
App,Pid,LIP,LPORT,RIP,RPORT,STATUS:string;
item:Tlistitem;
begin
try
Statusbar1.Panels[0].Text:='Retreiving Applications List ...';
Statusbar1.Refresh;
listview1.items.clear;
strlist:=Tstringlist.Create;
GetActiveConnections(strlist);
for I := 0 to strlist.Count - 1 do
begin
str:=strlist.Strings[i];
App:=Split(str,SEP,1);
Pid:=split(str,sep,2);
LIP:=split(str,sep,3);
Lport:=Split(str,SEP,4);
Rip:=split(str,sep,5);
rport:=split(str,sep,6);
status:=split(str,sep,7);

item:=Listview1.Items.Add;
item.Caption:=app;
item.SubItems.Add(pid);
item.SubItems.add(LIP);
item.SubItems.Add(Lport);
item.SubItems.Add(RIP);
item.SubItems.Add(RPORT);
item.SubItems.Add(status);

if status = 'LISTEN' then item.ImageIndex:=1
else
if status = 'ESTABLISHED' then item.ImageIndex:=0
else
item.ImageIndex:=2;



end;
strlist.Free;
Statusbar1.Panels[0].Text:='Done Successfully';
except
Statusbar1.Panels[0].Text:='Error in Operation';
end;

end;

procedure TForm39.SaveListtoTextFile1Click(Sender: TObject);
var
i,X:integer;
App,Pid,LIP,LPORT,RIP,RPORT,STATUS:string;
Strlist:Tstringlist;
ln:string;
begin
Savedialog1.InitialDir:=ExtractFilePath(paramstr(0));
if Savedialog1.Execute then
begin
Strlist:=Tstringlist.Create;
app:='Application';
Pid:='PID';
LIP:='Local IP';
LPORT:='Local Port';
RIP:='Remote IP';
RPORT:='Remote Port';
status:='Status';
if length(app) < 50 then for I := length(app) to 50 do app:=app+' ';
if length(PID) < 10 then for I := length(pid) to 10 do pid:=pid+' ';
if length(LIP) < 20 then for I := length(LIP) to 20 do LIP:=LIP+' ';
if length(LPORT) < 25 then for I := length(LPORT) to 25 do LPORT:=LPORT+' ';
if length(RIP) < 20 then for I := length(RIP) to 20 do RIP:=RIP+' ';
if length(RPORT) < 25 then for I := length(RPORT) to 25 do RPORT:=RPORT+' ';
if length(STATUS) < 10 then for I := length(STATUS) to 10 do STATUS:=STATUS+' ';
 
strlist.Add(App+PID+LIP+LPORT+RIP+RPORT+STATUS);
Strlist.Add('');

for X := 0 to listview1.Items.Count -1 do
begin  
App:=Listview1.Items[X].Caption;

if length(app) < 50 then for I := length(app) to 50 do app:=app+' ';
  
PID:=Listview1.Items[X].subitems[0];
if length(PID) < 10 then for I := length(pid) to 10 do pid:=pid+' ';

LIP:=Listview1.Items[X].subitems[1];
if length(LIP) < 20 then for I := length(LIP) to 20 do LIP:=LIP+' ';
LPORT:=Listview1.Items[X].subitems[2];
if length(LPORT) < 25 then for I := length(LPORT) to 25 do LPORT:=LPORT+' ';
RIP:=Listview1.Items[X].subitems[3];
if length(RIP) < 20 then for I := length(RIP) to 20 do RIP:=RIP+' ';
RPORT:=Listview1.Items[X].subitems[4];
if length(RPORT) < 25 then for I := length(RPORT) to 25 do RPORT:=RPORT+' ';
STATUS:=Listview1.Items[X].subitems[5];
strlist.Add(App+PID+LIP+LPORT+RIP+RPORT+STATUS);

end;

//MessageBox(0,pchar(strlist.Text),'',0);
Strlist.SaveToFile(Savedialog1.FileName);
end;
Statusbar1.Panels[0].Text:='List Saved to '+ExtractFilename(savedialog1.FileName);
end;

end.
