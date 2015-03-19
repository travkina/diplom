unit UStartStudy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, ShellApi;

type
  TStartStudy = class(TForm)
    OpenSelfControl: TSpeedButton;
    OpenFullControl: TSpeedButton;
    OpenTeaching: TSpeedButton;
    Cancel: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelClick(Sender: TObject);
    procedure OpenFullControlClick(Sender: TObject);
    procedure OpenSelfControlClick(Sender: TObject);
    procedure OpenTeachingClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    userName: String;
    userClass: String;
    { Public declarations }
  end;

var
  StartStudy: TStartStudy;

implementation

uses ULogin, UTeach, UFullControl, SelfControl, DS;

{$R *.dfm}

procedure TStartStudy.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  StartStudy := nil;
  Login := TLogin.Create(Application);
  Login.Show;
end;

procedure TStartStudy.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TStartStudy.OpenFullControlClick(Sender: TObject);
begin
    frmFullControl := TfrmFullControl.Create(Application);
    frmFullControl.strUserName := UserName;
    frmFullControl.Show;
    Hide;
end;

procedure TStartStudy.OpenSelfControlClick(Sender: TObject);
begin
    frmSelfControl := TfrmSelfControl.Create(Application);
    frmSelfControl.strUserName := UserName;
    frmSelfControl.Show;
    Hide;
end;

procedure TStartStudy.OpenTeachingClick(Sender: TObject);
begin
    frmTTeach := TfrmTTeach.Create(Application);
    frmTTeach.strUserName := UserName;
    frmTTeach.Show;
    Hide;
end;

procedure TStartStudy.FormPaint(Sender: TObject);
{var
    bmFon: TBitmap;}
begin
{  bmFon := TBitmap.Create;
  bmFon.LoadFromFile(ExtractFilePath(Application.ExeName) + 'pic\startstudyfon.bmp');
  StartStudy.Canvas.Draw(0, 0, bmFon);
  bmFon.Free;}
end;

procedure TStartStudy.SpeedButton1Click(Sender: TObject);
begin
    frmDs := TfrmDs.Create(Application);
    frmDs.strUserName := UserName;
    frmDS.userClass := userClass;
    frmDs.Show;
    Hide;
end;

end.
