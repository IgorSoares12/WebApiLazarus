unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  uApiRoutes, fpJson, jsonParser, fpWebFile, HttpDefs,
  HttpRoute;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnStartStop: TButton;
    edtPort: TEdit;
    imgStatusOff: TImage;
    imgStatusOn: TImage;
    lblStatus: TLabel;
    lblPort: TLabel;
    procedure btnStartStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //FUrl: string;
    Controller: TController;
    FServerActive: Boolean;
    procedure GetIndex(ARequest: TRequest; AResponse: TResponse);
    procedure StartServer;
    procedure StopServer;
    procedure ChangeStatusIcons(AActivated: Boolean);
  public

  end;

var
  MainForm: TMainForm;

const
  fileLocation = 'app';

implementation

{$R *.lfm}

uses
  {$IFDEF UNIX} cthreads, {$ENDIF} fpHttpApp;

{ TMainForm }

procedure TMainForm.btnStartStopClick(Sender: TObject);
begin
  if FServerActive then
    StopServer
  else
    StartServer;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not Assigned(Controller) then
    Controller := TController.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(Controller) then
    Controller.Free;
end;

procedure TMainForm.GetIndex(ARequest: TRequest; AResponse: TResponse);
begin
  AResponse.Code := 301;
  AResponse.SetCustomHeader('Location', fileLocation + '/index.html');
  AResponse.SendContent;
end;

procedure TMainForm.StartServer;
begin
  //Application.Port := StrToInt(edtPort.Text);
  //RegisterFileLocation(fileLocation, 'public_html');
  //HttpRouter.RegisterRoute('/', @GetIndex, true);
  //MimeTypesFile := ExtractFileDir(ParamStr(0)) + PathDelim + 'mime.types';
  //Controller.InitApp;
  Application.Threaded := True;
  ChangeStatusIcons(True);
  FServerActive := True;
end;

procedure TMainForm.StopServer;
begin
  Application.Threaded := False;
  ChangeStatusIcons(False);
  FServerActive := False;
end;

procedure TMainForm.ChangeStatusIcons(AActivated: Boolean);
begin
  if AActivated then
  begin
    imgStatusOn.Visible := True;
    imgStatusOff.Visible := False;
    lblStatus.Font.Color := clLime;
    lblStatus.Caption := 'Online';
  end
  else
  begin
    imgStatusOn.Visible := False;
    imgStatusOff.Visible := True;
    lblStatus.Font.Color := clBlack;
    lblStatus.Caption := 'Offline';
  end;
end;

end.

