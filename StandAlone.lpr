program StandAlone;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, cmem,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FormMain, fpJson, jsonParser, fpWebFile, HttpDefs,
  HttpRoute, fpHttpApp, SysUtils
  { you can add units after this };

{$R *.res}

const
  port = 8080;
  fileLocation = 'app';

procedure GetIndex(ARequest: TRequest; AResponse: TResponse);
begin
  AResponse.Code := 301;
  AResponse.SetCustomHeader('Location', fileLocation + '/index.html');
  AResponse.SendContent;
end;

begin
  RequireDerivedFormResource:=True;
//  Application.Scaled:=True;
  Application.Initialize;
  Application.Port := 8080;
  RegisterFileLocation(fileLocation, 'public_html');
  HttpRouter.RegisterRoute('/', @GetIndex, true);
  MimeTypesFile := ExtractFileDir(ParamStr(0)) + PathDelim + 'mime.types';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

