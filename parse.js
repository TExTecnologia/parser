'use strict'

const {toCamelCase, flatten, parser} = require('./lib/helpers')

const payload = require('./fixtures/quote.json')
const baseValue = {question: 'name',  fields: 'fieldValues'}

function riskAssessmentQuestions() {
	return new Map()
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Qual é o seu veículo?'), fields: ['ano_fabricacao', 'ano_modelo', 'marca', 'modelo']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('O veículo é Zero Km?'), fields: ['zero_km']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Quais são os itens originais de fábrica?'), fields: ['cambio_automatico', 'cambio_semiautomatico', 'freio_abs', 'ar_condicionado', 'ar_condicionado_digital', 'direcao_hidraulica', 'airbag_motorista', 'airbag_passageiro', 'banco_couro', 'travas_eletricas', 'vidro_eletrico', 'teto_solar']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Combustível?'), fields: ['combustivel']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Blindado?'), fields: ['blindado']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Antifurto?'), fields: ['dispositivo_antifurto']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Principal uso do veículo'), fields: ['uso']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Qual a placa do veículo'), fields: ['placa']}, baseValue)
		.set({prefix: /items.[0-9+].perfil.condutores.[0-9+]/, question: toCamelCase('Condutores'), fields: ['nome', 'sexo', 'data_nascimento', 'estado_civil', 'quantos_dias_dirige_na_semana', 'anos_habilitado']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Condutor Principal'), fields: ['cp_nome', 'cp_cpf', 'cp_sexo', 'cp_data_nascimento', 'cp_profissao', 'cp_reside_em', 'cp_total_veiculos', 'cp_vitima_roubo', 'cp_anos_habilitado', 'cp_filhos', 'cp_trabalha', 'cp_trabalha_hora', 'cp_diversao', 'cp_direcao_defensiva', 'cp_pratica_esporte', 'cp_moto_clube', 'cp_total_veiculo']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Onde o veículo passa a noite'), fields: ['local_pernoite']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Qual o CEP de onde o veículo passa a noite'), fields: ['local_cep_pernoite']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('O veículo fica na garagem quando está na residência?'), fields: ['garagem_residencia']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Quantos quilômetros você circula com o veículo?'), fields: ['km']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Utiliza o veículo para ir ao trabalho?'), fields: ['garagem_trabalho, km_trabalho']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Utiliza o veículo para ir estudar?'), fields: ['garagem_estudo']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Proprietário do veículo'), fields: ['nome_proprietario']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Dados do Proprietário do veículo'), fields: ['proprietario_sexo', 'proprietario_data_nascimento', 'proprietario_cpf_cnpj', 'proprietario_estado_civil']}, baseValue)
		.set({prefix: 'segurado', question: toCamelCase('Responsável pela contratação do seguro'), fields: ['nome', 'cpf', 'data_nascimento', 'email', 'telefone', 'celular']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Perfil do segurado'), fields: ['condutores_has_participacao', 'has_filhos17', 'has_direcao_defensiva', 'has_mais_veiculos', 'relacao_proprietario']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Perfil do segurado PJ'), fields: ['empresa_condutores_has_participacao', 'empresa_has_direcao_defensiva', 'empresa_relacao_condutor']}, baseValue)
		.set({prefix: /items.[0-9+].perfil/, question: toCamelCase('Existem residentes ou dependentes com idade entre 17 e 24 anos?'), fields: ['dependente_jovem', 'dependente_faixa', 'dependente_sexo']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Renovação'), fields: ['qual_seguradora', 'quantidade_sinistro', 'apolice_cobertura', 'apolice_is_mesmo_veiculo', 'apolice_mesmo_veiculo', 'apolice_tranferencia_titularidade', 'apolice_cancelamento_motivo', 'apolice_ini_vigencia', 'apolice_end_vigencia']}, baseValue)
		.set({prefix: /items.[0-9+]/, question: toCamelCase('Bonus'), fields: ['classe_bonus_anterior']}, baseValue)
}

// Executando
const questions = parser(flatten(payload), riskAssessmentQuestions())
const {quoteNumber, idBrocker, idCustomer} = JSON.parse(payload.segurado.extra_doc.replace(/&quot;/g, '"')) || {}
const paylodParsed = {
	quote: {
		quoteNumber,
		quoteNumberItau: 434534789,
		quoteNumberPorto: 94573493,
		quoteNumberAzul: 588563443,
		productName: 'seguro-auto',
		status: 'calculada',
		broker: {
			id: idBrocker,
			name: 'Fulano Corretor',
			susep: 123123,
			susepinha: 123123
		},
		customer: {
			id: idCustomer,
			cpf: payload.segurado.cpf,
			name: payload.segurado.nome
		},
		riskAssessmentQuestions: questions,
		offer: {
			premios: payload.premios || []
		}
	}
}

// Resultado
process.stdout.write(JSON.stringify(paylodParsed))
