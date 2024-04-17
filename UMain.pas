unit UMain;

interface

uses
  {$IFDEF ANDROID}
  Androidapi.JNI.JavaTypes, FMX.Helpers.Android, FMX.Platform.Android, Androidapi.Jni.Os,
  Androidapi.Jni.App, Androidapi.Jni.GraphicsContentViewText, Androidapi.Jni.Widget,
  Androidapi.Jni.Net, Androidapi.Helpers, Androidapi.Jni.Embarcadero,
  {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.Skia, FMX.Skia, FMX.SearchBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.Layouts, Data.Bind.GenData, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt;

type
  TMainForm = class(TForm)
    rectToolBar: TRectangle;
    lblTitleSearch: TLabel;
    Estilo: TStyleBook;
    btnSearch: TButton;
    SVGSearch: TSkSvg;
    ListView: TListView;
    btnHideSearch: TButton;
    SVGHideSearch: TSkSvg;
    rectSearchBackGround: TRectangle;
    EdtSearch: TEdit;
    LYSearch: TLayout;
    Prototype: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnHideSearchClick(Sender: TObject);
    procedure EdtSearchChangeTracking(Sender: TObject);
  private
    { Private declarations }
    procedure setSearchBox;
    {$IFDEF ANDROID}
    procedure setStatusBarColor(AColor: TAlphaColor);
    var
      FSearchTxtField_IsVisible: boolean;
    {$ENDIF}
    var
      SearchBox: TSearchBox;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

{ TMainForm }

procedure TMainForm.btnHideSearchClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  FSearchTxtField_IsVisible:= False;
  {$ENDIF}
  ListView.ItemIndex:= -1;
  EdtSearch.Text:= string.Empty;
  LYSearch.Visible:= False;
  lblTitleSearch.Visible:= True;
end;

procedure TMainForm.btnSearchClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  FSearchTxtField_IsVisible:= True;
  {$ENDIF}
  lblTitleSearch.Visible:= False;
  LYSearch.Visible:= True;
  EdtSearch.SetFocus;
end;

procedure TMainForm.EdtSearchChangeTracking(Sender: TObject);
begin
  if Assigned(SearchBox) then
  begin
    SearchBox.Text:= TEdit(Sender).Text;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
  setStatusBarColor(rectToolBar.Fill.Color);
  FSearchTxtField_IsVisible:= False;
  {$ENDIF}
  SearchBox:= TSearchBox.Create(Self);
  SearchBox.Parent:= Self;
  SearchBox.Align:= TAlignLayout.None;
  SearchBox.Visible:= False;
  setSearchBox;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  {$IFDEF ANDROID}
  if Key = vkHardwareBack then
  begin
    if FSearchTxtField_IsVisible then 
    begin
      ListView.ItemIndex:= -1;
      EdtSearch.Text:= string.Empty;
      FSearchTxtField_IsVisible:= False;
      LYSearch.Visible:= False;
      lblTitleSearch.Visible:= True;
      key:= 0;
    end;
  end;
  {$ENDIF}
end;

procedure TMainForm.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin

end;

{$IFDEF ANDROID}
procedure TMainForm.setStatusBarColor(AColor: TAlphaColor);
var
  Window: JWindow;
begin
  try
    Window:= TAndroidHelper.Activity.getWindow;
    Window.setStatusBarColor(TAndroidHelper.AlphaColorToJColor(AColor));
  except
    //Nothing
  end;
end;
{$ENDIF}

procedure TMainForm.setSearchBox;
var
  i: integer;
begin
  //ListView SearchVBox is only available if ListView.SearchVisible is True
  ListView.SearchVisible:= True;
  for i:= 0 to ListView.ControlsCount - 1 do
  begin
    if ListView.Controls[i].ClassType = TSearchBox then
    begin
      SearchBox.Model.SearchResponder:=
      TSearchBox(ListView.Controls[i]).Model.SearchResponder;
      Break;
    end;
  end;
  ListView.SearchVisible:= False;
end;

end.
