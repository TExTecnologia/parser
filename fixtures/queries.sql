set @calc_n = 14169;
set @calc_it = 1;

#calculo
select
	calc.calc_n as "calculo",
	calc.produtor,
	usua.usuario_id as "usuario",
	calc.unidade,
	calc.extra_document as "extra_doc",
	#Campos do Segurado
	calc.CPF as "cpf",
	calc.Nome_Cliente as "nome",
	calc.DT_NascS as "data_nascimento",
	coalesce(calc.Email_Particular,calc.Email_Comercial) as "email",
	concat(calc.DDD1, calc.Fone01) as "telefone",
	concat(calc.DDD_Cel, calc.Fone03) as "celular",
	calc.DT_IVig as "inicio_vigencia", calc.DT_TVig as "termino_vigencia",
	case calc.Tipo_Ren when 1 then 0 else 1 end as "is_renovacao",
	calc.TP_Pessoa as "tipo_pessoa"
from calculo calc
join produtor prod on prod.produtor_id = calc.produtor
join teleport.usuario usua on usua.produtor = prod.produtor_id and prod.empresa = usua.empresa
where calc.calc_n = @calc_n
;

#item
select
	cait.calc_n as "calculo",
	#Campos do Item
	cait.calc_it as "item",
	mfab.descricao as "marca",
	mvei.descricao as "modelo",
	cait.Placa as "placa",
	cait.Ano_Fabric as "ano_fabricacao",
	cait.Ano_Modelo as "ano_modelo",
	cait.Zero_KM as "zero_km",
	cait.Chassis as "chassi",
	comb.descricao as "combustivel",
	cait.tem_blind as "blindado",
	cait.tem_disp as "antifurto",
	cait.Cep_Pernoite as "local_cep_pernoite",
	cait.Cep_Circulacao as "local_cep_trabalho",
	cait.Proprietario as "nome_proprietario",
	#Originais de Fábrica
	cait.Ac_Cambio as "cambio_automatico",
	cait.AC_CambioSemi as "cambio_semiautomatico",
	cait.Ac_Freios as "freio_abs",
	cait.Ac_ArCond as "ar_condicionado",
	cait.Ac_ArCondDigital as "ar_condicionado_digital",
	cait.Ac_Direcao as "direcao_hidraulica",
	cait.Ac_AirBag as "airbag_motorista",
	cait.Ac_AirBagDuplo as "airbag_passageiro",
	cait.Ac_BancosCouro as "banco_couro",
	cait.Ac_TravaPorta as "travas_eletricas",
	cait.Ac_VidroEletrico as "vidro_eletrico",
	cait.Ac_TetoSolar as "teto_solar",
	#Renovação
	cait.Cia_Ant as "qual_seguradora",
	cait.Qtde_Sin as "quantidade_sinistro",
	rcob.resposta as "apolice_cobertura",
	cait.RenVeic as "apolice_is_mesmo_veiculo",
	cait.Categ_Ant as "apolice_mesmo_veiculo",
	rtti.resposta as "apolice_tranferencia_titularidade",
	rcan.resposta as "apolice_cancelamento_motivo",
	cait.Apl_Ant_Ivig as "apolice_ini_vigencia",
	cait.Apl_Ant_TVig as "apolice_end_vigencia",
	cait.Bonus_Ant as "classe_bonus_anterior"
from calculo_item cait
join mat_fab mfab on mfab.fabricante = cait.Cod_Marca
join mat_veic mvei on mvei.Mat_Veic = cait.Veiculo
join combustivel comb on comb.comb_id = cait.comb_id
left join tb_perfil rcob on rcob.tipo = 254 and rcob.valor = cait.CobAnt
left join tb_perfil rtti on rtti.tipo = 31 and rtti.valor = cait.Transf_Tit
left join tb_perfil rcan on rcan.tipo = 29 and rcan.valor = cait.CancAplAnterior
where cait.calc_n = @calc_n #and cait.calc_it = @calc_it
;

#perfil
select
	cape.calc_n as "calculo",
	cape.calc_it as "item",
	#Veiculo
	tuso.resposta as "uso",
	cape.KMPerc as "km",
	pern.resposta as "local_pernoite",
	gres.resposta as "garagem_residencia",
	gest.resposta as "garagem_estudo",
	gtra.resposta as "garagem_trabalho",
	dtra.resposta as "km_trabalho",
	#Proprietário
	#rseg.resposta as "relacao_segurado",
	psex.resposta as "proprietario_sexo",
	cape.DT_NascP as "proprietario_data_nascimento",
	cape.NumDoc2 as "proprietario_cpf_cnpj",
	peci.resposta as "proprietario_estado_civil",
	#Condutor Principal
	cape.Nome1 as "cp_nome",
	cape.NumDoc1 as "cp_cpf",
	cpse.resposta as "cp_sexo",
	cape.DataNasc1 as "cp_data_nascimento",
	cpro.resposta as "cp_profissao",
	cres.resposta as "cp_reside_em",
	EstGuarda4 as "cp_total_veiculos",
	csin.resposta as "cp_vitima_roubo",
	cape.Tempo_Habilit as "cp_anos_habilitado",
	cfil.resposta as "cp_filhos",
	ctra.resposta as "cp_trabalha",
	concat(Trabalho1,',', trabalho2,',', trabalho3) as "cp_trabalha_hora",
	cdiv.resposta as "cp_diversao",
	cdde.resposta as "cp_direcao_defensiva",
	cesp.resposta as "cp_pratica_esporte",
	cmcl.resposta as "cp_moto_clube",
	EstGuarda4 as "cp_total_veiculo",
	#Residente
	cape.Dependente_1724 as "dependente_jovem",
	cape.Faixa_Menor as "dependente_faixa",
	cape.Sexo_Menor as "dependente_sexo",
	#Renovação
	rmcp.resposta as "apolice_is_mesmo_condutor_principal",
	#Segurado
	spsi.resposta as "empresa_condutores_has_participacao",
	sdde.resposta as "empresa_has_direcao_defensiva",
	srel.resposta as "empresa_relacao_condutor",
	cape.SexoS as "segurado_sexo",
	cape.DT_NascS as "segurado_nascimento",
	seci.resposta as "segurado_estado_civil",
	cape.Estudante3 as "has_filhos17",
	spsi.resposta as "condutores_has_participacao",
	sdde.resposta as "has_direcao_defensiva",
	cape.Estudante4 as "has_mais_veiculos",
	rseg.resposta as "relacao_proprietario"
from calc_mperfil cape
left join tb_perfil tuso on tuso.tipo = 227 and tuso.valor = cape.UsoVeic1
left join tb_perfil pern on pern.tipo = 255 and pern.valor = cape.estudante2
left join tb_perfil gres on gres.tipo = 88 and gres.valor = cape.ResGuarda1
left join tb_perfil gest on gest.tipo = 3 and gest.valor = cape.EstGuarda1
left join tb_perfil gtra on gtra.tipo = 2 and gtra.valor = cape.TrabGuarda1
left join tb_perfil dtra on dtra.tipo = 67 and dtra.valor = cape.KMTrab
left join tb_perfil rseg on rseg.tipo = 8 and rseg.valor = cape.Ocupacao4
left join tb_perfil psex on psex.tipo = 5 and psex.valor = cape.SexoP
left join tb_perfil peci on peci.tipo = 6 and peci.valor = cape.EstadoCivilP
left join tb_perfil cpse on cpse.tipo = 5 and cpse.valor = cape.Sexo1
left join tb_perfil cpro on cpro.tipo = 43 and cpro.valor = cape.Profissao_ID
left join tb_perfil cres on cres.tipo = 13 and cres.valor = cape.ResGuarda4
left join tb_perfil csin on csin.tipo = 223 and csin.valor = cape.Sinistro_2Anos
left join tb_perfil cfil on cfil.tipo = 131 and cfil.valor = cape.FilhoA4
left join tb_perfil ctra on ctra.tipo = 17 and ctra.valor = cape.FilhoB4
left join tb_perfil cdiv on cdiv.tipo = 17 and cdiv.valor = cape.FilhoB1
left join tb_perfil cdde on cdde.tipo = 19 and cdde.valor = cape.TempoUtil4
left join tb_perfil cesp on cesp.tipo = 17 and cesp.valor = cape.FilhoC4
left join tb_perfil cmcl on cmcl.tipo = 254 and cmcl.valor = cape.MotoClube
left join tb_perfil rmcp on rmcp.tipo = 254 and rmcp.valor = cape.RelacaoSeg4
left join tb_perfil spsi on spsi.tipo = 17 and spsi.valor = cape.RenovSinis
left join tb_perfil sdde on sdde.tipo = 17 and sdde.valor = cape.Ocupacao1
left join tb_perfil srel on srel.tipo = 10 and srel.valor = cape.RelOutro1
left join tb_perfil seci on seci.tipo = 6 and seci.valor = cape.EstadoCivilS
where cape.calc_n = @calc_n and cape.calc_it = @calc_it
;

#condutores
select
	REPLACE(
		CONCAT_WS('', '[',
			(CASE WHEN (cape.C2Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C2Nome, '",',
					'"sexo": "', c2se.resposta, '",',
					'"data_nascimento": "', cape.C2DataNasc, '",',
					'"estado_civil": "', c2ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c2di.resposta, '",',
					'"anos_habilitado": "', cape.C2TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C3Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C3Nome, '",',
					'"sexo": "', c3se.resposta, '",',
					'"data_nascimento": "', cape.C3DataNasc, '",',
					'"estado_civil": "', c3ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c3di.resposta, '",',
					'"anos_habilitado": "', cape.C3TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C4Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C4Nome, '",',
					'"sexo": "', c4se.resposta, '",',
					'"data_nascimento": "', cape.C4DataNasc, '",',
					'"estado_civil": "', c4ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c4di.resposta, '",',
					'"anos_habilitado": "', cape.C4TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C5Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C5Nome, '",',
					'"sexo": "', c5se.resposta, '",',
					'"data_nascimento": "', cape.C5DataNasc, '",',
					'"estado_civil": "', c5ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c5di.resposta, '",',
					'"anos_habilitado": "', cape.C5TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C6Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C6Nome, '",',
					'"sexo": "', c6se.resposta, '",',
					'"data_nascimento": "', cape.C6DataNasc, '",',
					'"estado_civil": "', c6ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c6di.resposta, '",',
					'"anos_habilitado": "', cape.C6TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C7Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C7Nome, '",',
					'"sexo": "', c7se.resposta, '",',
					'"data_nascimento": "', cape.C7DataNasc, '",',
					'"estado_civil": "', c7ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c7di.resposta, '",',
					'"anos_habilitado": "', cape.C7TempoCNH, '"', '},')
			END),
			(CASE WHEN (cape.C8Nome IS NOT NULL) THEN CONCAT_WS('', '{'
					'"nome": "', cape.C8Nome, '",',
					'"sexo": "', c8se.resposta, '",',
					'"data_nascimento": "', cape.C8DataNasc, '",',
					'"estado_civil": "', c8ec.resposta, '",',
					'"quantos_dias_dirige_na_semana": "', c8di.resposta, '",',
					'"anos_habilitado": "', cape.C8TempoCNH, '"', '},')
			END),
		']'), '},]', '}]'
	) as "condutores"
from calc_mperfil cape
left join tb_perfil c2se on c2se.tipo = 5 and c2se.valor = cape.C2Sexo
left join tb_perfil c2ec on c2ec.tipo = 6 and c2ec.valor = cape.C2EstCivil
left join tb_perfil c2di on c2di.tipo = 232 and c2di.novovalor = cape.C2Dirige
left join tb_perfil c3se on c3se.tipo = 5 and c3se.valor = cape.C3Sexo
left join tb_perfil c3ec on c3ec.tipo = 6 and c3ec.valor = cape.C3EstCivil
left join tb_perfil c3di on c3di.tipo = 232 and c3di.novovalor = cape.C3Dirige
left join tb_perfil c4se on c4se.tipo = 5 and c4se.valor = cape.C4Sexo
left join tb_perfil c4ec on c4ec.tipo = 6 and c4ec.valor = cape.C4EstCivil
left join tb_perfil c4di on c4di.tipo = 232 and c4di.novovalor = cape.C4Dirige
left join tb_perfil c5se on c5se.tipo = 5 and c5se.valor = cape.C5Sexo
left join tb_perfil c5ec on c5ec.tipo = 6 and c5ec.valor = cape.C5EstCivil
left join tb_perfil c5di on c5di.tipo = 232 and c5di.novovalor = cape.C5Dirige
left join tb_perfil c6se on c6se.tipo = 5 and c6se.valor = cape.C6Sexo
left join tb_perfil c6ec on c6ec.tipo = 6 and c6ec.valor = cape.C6EstCivil
left join tb_perfil c6di on c6di.tipo = 232 and c6di.novovalor = cape.C6Dirige
left join tb_perfil c7se on c7se.tipo = 5 and c7se.valor = cape.C7Sexo
left join tb_perfil c7ec on c7ec.tipo = 6 and c7ec.valor = cape.C7EstCivil
left join tb_perfil c7di on c7di.tipo = 232 and c7di.novovalor = cape.C7Dirige
left join tb_perfil c8se on c8se.tipo = 5 and c8se.valor = cape.C8Sexo
left join tb_perfil c8ec on c8ec.tipo = 6 and c8ec.valor = cape.C8EstCivil
left join tb_perfil c8di on c8di.tipo = 232 and c8di.novovalor = cape.C8Dirige
where cape.calc_n = @calc_n and cape.calc_it = @calc_it
;
