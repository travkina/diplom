unit UEntry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB;

type
  TEntry = class(TForm)
    regUser: TButton;
    Button3: TButton;
    cancel: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    enter: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancelClick(Sender: TObject);
    procedure enterClick(Sender: TObject);
    procedure regUserClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Entry: TEntry;
  contextPath: String;

implementation

uses ULogin, UAddUser;

{$R *.dfm}

procedure TEntry.FormCreate(Sender: TObject);
begin
    AddFontResource(PChar(ExtractFilePath(Application.ExeName) + '\phontm.ttf'));
    contextPath := ExtractFilePath(Application.ExeName);

    if ( not FileExists(DataLinkDir + '\ph.udl') ) then
    begin
        try
            CreateUDLFile(DataLinkDir + '\ph.udl', 'Microsoft.Jet.OLEDB.4.0', contextPath + 'db\phonetics_db.mdb');
        except
            Exception.Create('Can not creat udl file');
        end;
    end
    else
    begin
        DeleteFile(DataLinkDir + '\ph.udl');
        try
            CreateUDLFile(DataLinkDir + '\ph.udl', 'Microsoft.Jet.OLEDB.4.0', contextPath + 'db\phonetics_db.mdb');
        except
            Exception.Create('Can not creat udl file');
        end;
    end;
end;

procedure TEntry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    Entry := nil;
    RemoveFontResource(PChar(ExtractFilePath(Application.ExeName) + 'phontm.ttf'));
    Application.Terminate;
end;

procedure TEntry.cancelClick(Sender: TObject);
begin
    Close;
end;

procedure TEntry.enterClick(Sender: TObject);
var
    lin: TLogin;
begin
    Hide;
    lin := TLogin.Create(Application);
    lin.Show;
end;

procedure TEntry.regUserClick(Sender: TObject);
begin
    AddUser := TAddUser.Create(Application);
    AddUser.Show;
    Hide;
end;

end.
