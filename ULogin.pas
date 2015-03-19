unit ULogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, DB;

type
  TLogin = class(TForm)
    labelLogin: TStaticText;
    StaticText3: TStaticText;
    Ok: TButton;
    Cancel: TButton;
    Grade: TDBLookupComboBox;
    Password: TEdit;
    login: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GradeExit(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    { Private declarations }
    procedure fillLoginByGradeId(gradeId: Integer);
    function isUserExist(login: String; gradeId: Integer; pass: String): Boolean;
  public
    { Public declarations }
  end;

var
    Login: TLogin;
    contextPath: String;

implementation

uses UEntry, UDM, UStartStudy;

{$R *.dfm}

procedure TLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    Login := nil;

    with DM do
    begin
        GradeTable.Close;
        UserByGradeId.Close;
    end;
end;

procedure TLogin.CancelClick(Sender: TObject);
begin
    Close;
    Entry.Show;
end;

procedure TLogin.FormCreate(Sender: TObject);
begin
    contextPath := ExtractFilePath(Application.ExeName);

    with DM do
    begin
        GradeTable.Open;
    end;
end;

procedure TLogin.GradeExit(Sender: TObject);
var
    q: String;
    g: Integer;
begin
    if ( Grade.KeyValue <> Null ) then
    begin
        g := Grade.KeyValue;
        fillLoginByGradeId(g);
 {       q := 'select login, id from us_user where grade_id=' + g;
        DM.UserByGradeId.SQL.Clear;
        DM.UserByGradeId.SQL.Add(q);
        DM.UserByGradeId.ExecSQL;
        DM.UserByGradeId.Open;}
    end;
end;

procedure TLogin.OkClick(Sender: TObject);
begin
    if ( Length(Trim(Grade.Text)) = 0 ) then
    begin
        ShowMessage('Вы выбрали класс!');
        exit;
    end;
    if ( isUserExist(login.Text, Grade.KeyValue, Password.Text) ) then
    begin
        StartStudy := TStartStudy.Create(Application);
        StartStudy.Show;
        StartStudy.userName := login.Text;
        StartStudy.userClass := Grade.Text;
        Self.Close;
    end
    else
        ShowMessage('Вы ввели неправильный пароль');

    with DM.UserTable do
    begin
        Open;
{        if ( Locate('id;grade_id;password', VarArrayOf([FIO.KeyValue, Grade.KeyValue, Password.Text]), [loPartialKey])) then
        begin
        end
        else begin
            ShowMessage('Вы ввели неправильный пароль');
        end;}
        Close;
    end;
end;

procedure TLogin.fillLoginByGradeId(gradeId: Integer);
var
    q: String;
    i: Integer;
    l: String;
begin
    q := 'select login, id from us_user where grade_id=' + IntToStr(gradeId);
    with dm do begin
        UserByGradeId.Close();
        UserByGradeId.SQL.Clear();
        UserByGradeId.SQL.Add(q);
        UserByGradeId.Open();

        UserByGradeId.First;
        for i := 0 to UserByGradeId.RecordCount - 1 do begin
            l := UserByGradeId.fieldByName('login').AsString;
            login.Items.Add(l);
            UserByGradeId.Next();
        end;
    end;
end;

function TLogin.isUserExist(login: String; gradeId: Integer;
  pass: String): Boolean;
var
    q: String;
    var i: Integer;
begin
    if ( (Length(Trim(login)) = 0) or (gradeId < 0)
        or (Length(Trim(pass)) = 0) ) then
    begin
        ShowMessage('Выберите класс,псевдоним и введите пароль!');
        Result := false;
        exit;
    end;

    q := 'SELECT id FROM us_user WHERE login=''' + login + ''' and grade_id=' + IntToStr(gradeId) + ' and password=''' + pass + '''';

    with dm do
    begin
        query.Close();
        query.SQL.Clear();
        query.SQL.Add(q);
        query.Open();
        if ( query.RecordCount > 0 ) then
            Result := true
        else
            Result := false;    
    end;
end;

end.
