//---------------------------------------------------------------------------

// This software is Copyright (c) 2021 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit View.NewForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Main, FMX.Effects, FMX.Layouts, FMX.Ani, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.JSON;

type
  TNewFormFrame = class(TMainFrame)
    EdtAccKey: TEdit;
    EdtPhoneNum: TEdit;
    PnlParams: TPanel;
    CBBCountryCode: TComboBox;
    ChkFormat: TCheckBox;
    BtnRequest: TButton;
    MemResponse: TMemo;
    RctInfo: TRectangle;
    LblValid: TLabel;
    LblCountry: TLabel;
    LblLocation: TLabel;
    LblLineType: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    procedure BtnRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TNewFormFrame.BtnRequestClick(Sender: TObject);
begin
  inherited;
  var IsDebug := '';

  MemResponse.Lines.Clear;

  RESTClient1.ResetToDefaults;
  RESTClient1.Accept := 'application/json';
  RESTClient1.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient1.BaseURL := 'http://apilayer.net/api/validate';

  if ChkFormat.IsChecked then
  begin
    IsDebug := '1'
  end
  else
    IsDebug := '0';

  RESTRequest1.Resource := Format('?access_key=%s&number=%s&country_code=%s&format=%s',
    [EdtAccKey.Text, EdtPhoneNum.Text, CBBCountryCode.Selected.Text, IsDebug]);
  RESTResponse1.ContentType := 'application/json';

  // send request
  RESTRequest1.Execute;

  // get values from JSON
  var JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);
  try
    if JSONValue is TJSONObject then
    begin
      LblValid.Text := 'IsValid: ' + JSONValue.GetValue<string>('valid');
      LblCountry.Text := 'Country: ' + JSONValue.GetValue<string>('country_name');
      LblLocation.Text := 'Location: ' + JSONValue.GetValue<string>('location');
      LblLineType.Text := 'Line Type: ' + JSONValue.GetValue<string>('line_type');
    end;
  finally
    JSONValue.Free;
  end;

end;

initialization
  // Register frame
  RegisterClass(TNewFormFrame);
finalization
  // Unregister frame
  UnRegisterClass(TNewFormFrame);

end.
