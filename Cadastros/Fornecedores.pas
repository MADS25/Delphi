unit Fornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmFornecedores = class(TForm)
    lb_buscars: TLabel;
    lb_nome: TLabel;
    lb_end: TLabel;
    lb_telefone: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    EdtBuscar: TEdit;
    EdtTelefone: TMaskEdit;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    EdtNome: TEdit;
    EdtProduto: TEdit;
    Edtendereco: TEdit;
    procedure btnNovoClick(Sender: TObject);
    procedure EdtBuscarChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);

  private
    { Private declarations }
      procedure limpar;
      procedure verificaCadastro;
      procedure habilitarCampos;
      procedure desabilitarCampos;
      procedure associarCampos;
      procedure listar;
      procedure buscar;

  public
    { Public declarations }
  end;

var
  FrmFornecedores: TFrmFornecedores;
    id : String;
    nomeAntigo  : String;

implementation

{$R *.dfm}

uses Modulo;
procedure TFrmFornecedores.verificaCadastro;

  begin
    //verificar se o fornecedor  j� est� cadastrado
    dm.query_forn.Close;
    dm.query_forn.SQL.Clear;
    dm.query_forn.SQL.Add('SELECT * FROM fornecedores WHERE nome = ' + QuotedStr(Trim(EdtNome.Text)));
    dm.query_forn.Open;
  end;

procedure TFrmFornecedores.limpar;
begin
    EdtNome.Text :='';
    EdtProduto.Text :='';
    EdtEndereco.Text :='';
    EdtTelefone.Text :='';
end;

procedure TFrmFornecedores.habilitarCampos;
begin
    EdtNome.Enabled := True;
    EdtProduto.Enabled := True;
    EdtEndereco.Enabled := True;
    EdtTelefone.Enabled := True;
end;

procedure TFrmFornecedores.desabilitarCampos;
begin
    EdtNome.Enabled := False;
    EdtProduto.Enabled := False;
    EdtEndereco.Enabled := False;
    EdtTelefone.Enabled := False;
end;

procedure TFrmFornecedores.EdtBuscarChange(Sender: TObject);
begin
 if EdtBuscar.Text <> '' then
  begin
     buscar;
  end
  else
  begin
   listar;
  end;
end;

procedure TFrmFornecedores.FormShow(Sender: TObject);
begin
  desabilitarCampos;
  dm.tb_forn.Active := True;
  listar;
end;

procedure TFrmFornecedores.associarCampos;
begin
    dm.tb_forn.FieldByName('nome').Value := EdtNome.Text;
    dm.tb_forn.FieldByName('produto').Value := EdtProduto.Text;
    dm.tb_forn.FieldByName('telefone').Value := EdtTelefone.Text;
    dm.tb_forn.FieldByName('endereco').Value := EdtEndereco.Text;
    dm.tb_forn.FieldByName('data').Value := DateToStr(Date);
end;

procedure TFrmFornecedores.listar;
begin
    dm.query_forn.Close;
    dm.query_forn.SQL.Clear;
    dm.query_forn.SQL.Add('SELECT * FROM fornecedores order by nome asc');
    dm.query_forn.Open;
end;

procedure TFrmFornecedores.buscar;
begin
    dm.query_forn.Close;
    dm.query_forn.SQL.Clear;
    dm.query_forn.SQL.Add('SELECT * FROM fornecedores WHERE nome LIKE :nome order by nome asc');
    dm.query_forn.ParamByName('nome').Value := EdtBuscar.Text + '%';
    dm.query_forn.Open;
end;

procedure TFrmFornecedores.DBGrid1CellClick(Column: TColumn);
begin
    habilitarCampos;

    EdtNome.Enabled := True;
    BtnEditar.Enabled := True;
    BtnExcluir.Enabled := True;

     dm.tb_forn.Edit;

     EdtNome.Text := dm.query_forn.FieldByName('nome').Value;
     EdtProduto.Text := dm.query_forn.FieldByName('produto').Value;
     EdtTelefone.Text := dm.query_forn.FieldByName('telefone').Value;
     EdtEndereco.Text := dm.query_forn.FieldByName('endereco').Value;

     id := dm.query_forn.FieldByName('id').Value;
     nomeAntigo := dm.query_forn.FieldByName('nome').Value;
end;

procedure TFrmFornecedores.DBGrid1DblClick(Sender: TObject);
begin
  if chamada = 'Forn' then
  begin
    idFornecedor      := dm.query_forn.FieldByName('id').Value;
    nomeFornecedor    := dm.query_forn.FieldByName('nome').Value;
    Close;
    chamada := '';
  end;
end;

procedure TFrmFornecedores.btnEditarClick(Sender: TObject);
var nome: string;
  begin

  if Trim(EdtNome.Text) = '' then
      begin
        MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
        EdtNome.SetFocus;
        exit;
      end;

      if Trim(EdtProduto.Text) = '' then
      begin
        MessageDlg('Preencha o Produto!', mtInformation, mbOKCancel, 0);
        EdtProduto.SetFocus;
        exit;
      end;

      if nomeAntigo <> EdtNome.Text then
      begin
        verificaCadastro;
        if not dm.query_forn.IsEmpty then
           begin
             nome := dm.query_forn['nome'];
             MessageDlg('O nome ' + nome + ' j� esta cadastrado!', mtInformation, mbOKCancel, 0);
             EdtNome.Text := '';
             EdtNome.SetFocus;
             Exit;
           end;
      end;

    associarCampos;

    dm.query_forn.Close;
    dm.query_forn.SQL.Clear;
    dm.query_forn.SQL.Add('UPDATE fornecedores set nome = :nome, produto = :produto, endereco = :endereco, telefone = :telefone WHERE id = :id');
    dm.query_forn.ParamByName('nome').Value := EdtNome.Text;
    dm.query_forn.ParamByName('produto').Value := EdtProduto.Text;
    dm.query_forn.ParamByName('endereco').Value := EdtEndereco.Text;
    dm.query_forn.ParamByName('telefone').Value := EdtTelefone.Text;
    dm.query_forn.ParamByName('id').Value := id;
    dm.query_forn.ExecSQL;



    listar;
    MessageDlg('Editado com sucesso!!', mtInformation, mbOKCancel, 0);
    btnEditar.Enabled := False;
    btnExcluir.Enabled := False;
    btnSalvar.Enabled := False;
    limpar;
    desabilitarCampos;

end;

procedure TFrmFornecedores.btnExcluirClick(Sender: TObject);
begin
  if MessageDlg('Deseja Excluir o registro?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    dm.tb_forn.Close;
     dm.tb_forn.SQL.Clear;
     dm.tb_forn.SQL.Add('DELETE FROM fornecedores WHERE id = :id');
     dm.tb_forn.ParamByName('id').Value := id;
     dm.tb_forn.ExecSQL;

    MessageDlg('Deletado com Sucesso!', mtInformation, mbOKCancel,0);
    btnEditar.Enabled := False;
    btnExcluir.Enabled := False;
    btnSalvar.Enabled := False;

    limpar;
    desabilitarCampos;
    listar;
  end;
end;

procedure TFrmFornecedores.btnNovoClick(Sender: TObject);
begin
   habilitarCampos;
   dm.tb_forn.Insert;
   btnSalvar.Enabled := True;

end;

procedure TFrmFornecedores.btnSalvarClick(Sender: TObject);
var
nome: string;
begin
     if Trim(EdtNome.Text) = '' then
      begin
        MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
        EdtNome.SetFocus;
        exit;
      end;

       if Trim(EdtProduto.Text) = '' then
      begin
        MessageDlg('Preencha o Produto!', mtInformation, mbOKCancel, 0);
        EdtProduto.SetFocus;
        exit;
      end;


    verificaCadastro;

      if not dm.query_forn.IsEmpty then
     begin
       nome := dm.query_forn['nome'];
       MessageDlg('O nome ' + nome + ' j� esta cadastrado!', mtInformation, mbOKCancel, 0);
       EdtNome.Text := '';
       EdtNome.SetFocus;
       Exit;
     end;

    associarCampos;
    dm.tb_forn.Post;
    MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel,0);
    limpar;
    btnSalvar.Enabled := false;
    desabilitarCampos;
    listar;
end;

end.
