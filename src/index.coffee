# Software complexity analysis for CoffeeScript projects.
# CoffeeScript-specific wrapper around escomplex.

'use strict'

coffee = require 'coffee-script'
escomplex = require 'escomplex'
walker = require './walker'

# Public function `analyse`.
#
# Returns an object detailing the complexity of CoffeeScript source code.
#
# @param source {object|array}  The source code to analyse for complexity.
# @param [options] {object}     Options to modify the complexity calculation.
analyse = (source, options) ->
  if Array.isArray source
    return escomplex.analyse source.map((s) ->
      { ast: getAst(s.code), path: s.path }
    ), walker, options

  escomplex.analyse getAst(source), walker, options

exports.analyse = analyse

getAst = (source) ->
  ast = coffee.nodes(source)
  lastExp = ast.expressions[ast.expressions.length - 1]
  ast.loc = {
    start: {
      line: ast.locationData.first_line
    },
    end: {
      line: lastExp.locationData.last_line
    }
  }
  ast
