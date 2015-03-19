unit UAddUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ADODB, DB, UUser;

type
  TAddUser = class(TForm)
    StaticText1: TStaticText;
    lastName: TEdit;
    firstName: TEdit;
    patronymic: TEdit;
    password: TEdit;
    repeatPassword: TEdit;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Grade: TDBLookupComboBox;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    ok: TButton;
    cancel: TButton;
    StaticText7: TStaticText;
    otherGrade: TEdit;
    addGrade: TButton;
    withoutPassword: TCheckBox;
    loginLabel: TStaticText;
    login: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cancelClick(Sender: TObject);
    procedure addGradeClick(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure withoutPasswordClick(Sender: TObject);
  private
    { Private declarations }
    function validateUserInfo(): Boolean;
    function validatePassword(): Boolean;
    function isUserExist(param: TUser): Boolean;
  public
    { Public declarations }
  end;

var
  AddUser: TAddUser;

implementation

uses UDM, UEntry, UGrade;

{$R *.dfm}

procedure TAddUser.FormCreate(Sender: TObject);
begin
    DM.GradeTable.Open
end;

procedure TAddUser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    AddUser := nil;
    DM.GradeTable.Close;
    Entry.Show;
end;

procedure TAddUser.cancelClick(Sender: TObject);
begin
    Close;
end;

procedure TAddUser.addGradeClick(Sender: TObject);
var
    grade: TGrade;
begin
    if ( trim(otherGrade.Text) <> '' ) then
    begin
        grade := TGrade.Create();
        grade.name := otherGrade.Text;

        if ( grade.store(grade) ) then
        begin
            ShowMessage('Класс ' + grade.name + ' успешно добавлен');
            otherGrade.Text := '';
        end
        else
            ShowMessage('Не удалось добавить класс');

        FreeAndNil(grade);
    end
    else
        ShowMessage('Поле другой класс не заполнено!');

    DM.GradeTable.Open
end;

procedure TAddUser.okClick(Sender: TObject);
var
    user: TUser;
begin
    {TODO: Add userId for enter in system by userId?}
    if ( validateUserInfo() = true ) then
    begin
        if ( validatePassword() = true ) then
        begin
            user := TUser.Create;
            user.login := trim(login.Text);
            user.FIO := lastName.Text + ' ' + firstName.Text + ' ' + patronymic.Text;
            user.password := password.Text;
            user.gradeId := Grade.KeyValue;
            if ( isUserExist(user) ) then
            begin
                ShowMessage('Пользователь c псевдонимом ' + user.login + ' уже существуе');
                FreeAndNil(user);
                exit;
            end;
            if ( user.store(user) ) then
            begin
                ShowMessage('Пользователь ' + user.FIO + ' успешно добавлен');
                Close;
            end
            else
                ShowMessage('Не удалось добавить пользователя');

            FreeAndNil(user);
        end
        else
        begin
            ShowMessage('Пароли не совпадают. Введите пароль еще раз');
            password.Text := '';
            repeatPassword.Text := '';
            password.SetFocus;
        end;
    end
    else
        ShowMessage('Вы заполнили не все поля!');
end;

procedure TAddUser.withoutPasswordClick(Sender: TObject);
begin
    if (withoutPassword.Checked) then begin
        password.Enabled := false;
        repeatPassword.Enabled := false;
    end else begin
        password.Enabled := true;
        repeatPassword.Enabled := true;
    end;
end;

function TAddUser.validateUserInfo: Boolean;
begin
    Result := true;
    if ( Trim(login.Text) = '' ) then
        Result := false;
    if ( Trim(lastName.Text) = '' ) then
        Result := false;
    if ( Trim(firstName.Text) = '' ) then
        Result := false;
    if ( Trim(patronymic.Text) = '' ) then
        Result := false;
    if ( Trim(patronymic.Text) = '' ) then
        Result := false;
    if ( Trim(Grade.Text) = '' ) then
        Result := false;
    if ( withoutPassword.Checked = false ) then begin
        if ( Trim(password.Text) = '' ) then
            Result := false;
        if ( Trim(repeatPassword.Text) = '' ) then
            Result := false;
    end;
end;

function TAddUser.validatePassword: Boolean;
begin
    Result := true;
    if ( withoutPassword.Checked = false ) then
        if ( password.Text <> repeatPassword.Text ) then
            Result := false;
end;

function TAddUser.isUserExist(param: TUser): Boolean;
var
    queryString: String;
    i: Integer;
    j: Integer;
begin
    j := 0;
    Result := false;
    queryString := 'SELECT ' +
                        'id ' +
                    'FROM ' +
                        'us_user ' +
                    'WHERE ' +
                        'login=''' + param.login + ''' ' +
                        'and grade_id=' + IntToStr(param.gradeId)
    ;

    with dm.query do begin
        Close();
        try
            SQL.Clear();
            SQL.Add(queryString);
            Open();
            First;
            for i := 0 to RecordCount - 1 do
                j := j + 1;
        finally
            Close();
        end;
    end;
    if ( j > 0 ) then
        Result := true;
end;

end.
