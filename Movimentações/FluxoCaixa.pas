unit FluxoCaixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.StdCtrls, RelatoriosPorDatas;

type
  TFrmFluxoCaixa = class(TForm)
    Label5: TLabel;
    dataBuscar: TDateTimePicker;
    DBGrid1: TDBGrid;
    btnRelatorio: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure dataBuscarChange(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);

  private
    { Private declarations }
    procedure buscarData;

  public
    { Public declarations }
  end;

var
  FrmFluxoCaixa: TFrmFluxoCaixa;

implementation

{$R *.dfm}

uses Modulo;


{ TFrmFluxoCaixa }

procedure TFrmFluxoCaixa.btnRelatorioClick(Sender: TObject);
begin
  rel := 'Caixa';
  FrmRelDatas := TFrmRelDatas.Create(self);
  FrmRelDatas.ShowModal;
end;

procedure TFrmFluxoCaixa.buscarData;
begin
  dm.query_caixa.Close;
  dm.query_caixa.SQL.Clear;
  dm.query_caixa.SQL.Add('SELECT * from caixa where data_abertura = :data order by data_abertura desc');
  dm.query_caixa.ParamByName('data').Value := FormatDateTime('yyyy/mm/dd' ,dataBuscar.Date);
  dm.query_caixa.Open;
end;

procedure TFrmFluxoCaixa.dataBuscarChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmFluxoCaixa.FormShow(Sender: TObject);
begin
  dm.tb_caixa.Active := True;
  dataBuscar.Date := Date;
  buscarData;
end;

end.
