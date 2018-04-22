if exists('g:protobuf_plugin_loaded')
  finish
endif
let g:protobuf_plugin_loaded = 1

let g:protobuf#protobuf_path = get(g:, 'protobuf#protoc_path',
\ '/usr/local/bin/protoc')

let g:protobuf#grpc_cpp_plugin = get(g:, 'protobuf#grpc_cpp_plugin',
\ '/usr/local/bin/grpc_cpp_plugin')

let g:protobuf#grpc_csharp_plugin = get(g:, 'protobuf#grpc_csharp_plugin',
\ '/usr/local/bin/grpc_csharp_plugin')

let g:protobuf#grpc_node_plugin = get(g:, 'protobuf#grpc_node_plugin',
\ '/usr/local/bin/grpc_node_plugin')

let g:protobuf#grpc_objective_c_plugin = get(g:,
\ 'protobuf#grpc_objective_c_plugin',
\ '/usr/local/bin/grpc_objective_c_plugin')

let g:protobuf#grpc_php_plugin = get(g:, 'protobuf#grpc_php_plugin',
\ '/usr/local/bin/grpc_php_plugin')

let g:protobuf#grpc_python_plugin = get(g:, 'protobuf#grpc_python_plugin',
\ '/usr/local/bin/grpc_python_plugin')

let g:protobuf#grpc_ruby_plugin = get(g:, 'protobuf#grpc_ruby_plugin',
\ '/usr/local/bin/grpc_ruby_plugin')


function! ProtocExist()
  if filereadable(g:protobuf#protobuf_path)
    return 1
  endif
  return 0
endfunction

function! CheckProtoExtension()
  if expand('%:e') == 'proto'
    return 1
  endif
  return 0
endfunction

function! CheckPluginExist(plugin)
  if filereadable(a:plugin)
    return 1
  endif
  return 0
endfunction

function! g:protobuf#GenerateProto(type)
  if ProtocExist() && CheckProtoExtension()
    let b:protoc_command = g:protobuf#protobuf_path .
          \ ' -I ' . expand('%:p:h') .
          \ ' ' . expand('%:p') .
          \ ' --' . a:type . '_out=. '
    silent execute '!' . b:protoc_command
  endif
endfunction

function! g:protobuf#GenerateGRPC(type)
  let b:plugin = get(g:, 'protobuf#grpc_' . a:type . '_plugin', '')
  if ProtocExist() && CheckProtoExtension() && CheckPluginExist(b:plugin)
    let b:protoc_command = g:protobuf#protobuf_path .
          \ ' -I ' . expand('%:p:h') .
          \ ' ' . expand('%:p') .
          \ ' --plugin=protoc-gen-grpc=' . b:plugin .
          \ ' --grpc_out=.'
    silent execute '!' . b:protoc_command
  endif
endfunction

command! GenerateCppProto call g:protobuf#GenerateProto('cpp')
command! GenerateCsharpProto call g:protobuf#GenerateProto('csharp')
command! GenerateNodeProto call s:protobuf#GenerateProto('node')
command! GenerateObjectiveCProto call g:protobuf#GenerateProto('objective_c')
command! GeneratePHPProto call g:protobuf#GenerateProto('php')
command! GeneratePythonProto call g:protobuf#GenerateProto('python')
command! GenerateRubyProto call g:protobuf#GenerateProto('ruby')

command! GenerateCppGRPC call g:protobuf#GenerateGRPC('cpp')
command! GenerateCsharpGRPC call g:protobuf#GenerateGRPC('csharp')
command! GenerateNodeGRPC call g:protobuf#GenerateGRPC('node')
command! GenerateObjectiveCGRPC call g:protobuf#GenerateGRPC('objective_c')
command! GeneratePHPGRPC call g:protobuf#GenerateGRPC('php')
command! GeneratePythonGRPC call g:protobuf#GenerateGRPC('python')
command! GenerateRubyGRPC call g:protobuf#GenerateGRPC('ruby')
