
//---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc. 
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------
program GettingStarted;

uses
  Forms,
  GettingStarted.Main.Form in 'GettingStarted.Main.Form.pas' {GettingStartedMainForm},
  GettingStared.Config in 'Config\GettingStared.Config.pas',
  GettingStarted.Main.DataModule in 'GettingStarted.Main.DataModule.pas' {MainDataModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGettingStartedMainForm, GettingStartedMainForm);
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.Run;
end.
