'use strict'

const uniq = require('lodash.uniq')
const {createSlug} = require('speakingurl')

// Helper camelCase
const _slug = createSlug({
	titleCase: true,
	separator: '_'
})

// Transforma string em camelCase ex.: Apenas um show -> ApenasUmShow
function toCamelCase(str) {
	return _slug(str).split('_').map(v => v.length > 1 ? v : '').join('')
}

/* Retorna um objeto com apenas 1 nivel ex.:

>>

{
	a: {
		b: {
			c: 'foo bar'
		}
	}
}

<<

{
	'a.b.c': 'foo bar'
}

// */
function flatten(object, separator = '.') {
	return Object.assign({}, ...function _flatten(child, path = []) {
		return [].concat(...Object.keys(child).map(key => {
			if (typeof child[key] === 'object' && child[key] !== null && child[key] !== undefined) {
				return _flatten(child[key], path.concat([key]))
			}
			return {[path.concat([key]).join(separator)]: child[key]}
		}))
	}(object))
}

// Helper parse
function _loop(data, prefix, fieldsKey, arr) {
	for (const field of fieldsKey) {
		if (data[`${prefix}.${field}`]) {
			arr.push({
				field,
				value: data[`${prefix}.${field}`]
			})
		}
	}
	return arr
}

// Parse
function parser(...args) {
	const [data, map] = args
	const dataKeys = Object.keys(data)
	const out = []
	for (const [oKey, oValue] of map.entries()) {
		const item = Object.create(null)
		const {prefix, question: questionKey, fields: fieldsKey} = oKey
		const {question: questionVal, fields: fieldsVal} = oValue

		// Verifica se prefixo é um regex
		let prefixes
		if (prefix instanceof RegExp) {
			prefixes = uniq(dataKeys.filter(el => prefix.test(el)).map(el => el.split('.').slice(0, prefix.toString().split('.').length).join('.')))
		}

		// Define o name do bloco
		item[questionVal] = questionKey

		// Bloco array
		if (Array.isArray(prefixes)) {
			item[fieldsVal] = []
			for (const prefix of prefixes) {
				const groups = _loop(data, prefix, fieldsKey, [])
				item[fieldsVal].push(groups)
			}
		// Bloco unico
		} else {
			item[fieldsVal] = _loop(data, prefix, fieldsKey, [])
		}
		out.push(item)
	}
	return out
}

exports.toCamelCase = toCamelCase
exports.flatten = flatten
exports.parser = parser
