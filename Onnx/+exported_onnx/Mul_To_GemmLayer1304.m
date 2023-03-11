classdef Mul_To_GemmLayer1304 < nnet.layer.Layer & nnet.layer.Formattable
    % A custom layer auto-generated while importing an ONNX network.
    
    %#codegen
    %#ok<*PROPLC>
    %#ok<*NBRAK>
    %#ok<*INUSL>
    %#ok<*VARARG>
    
    properties (Learnable)
        Encoders_layers_0__5
        Encoders_layers_0__6
        Encoders_layers_1__5
        Encoders_layers_1__6
        Encoders_layers_2__5
        Encoders_layers_2__6
        Encoders_layers_3__5
        Encoders_layers_3__6
        Encoders_layers_4__5
        Encoders_layers_4__6
        Encoders_layers_5__5
        Encoders_layers_5__6
        head_bias
        head_weight
        onnx__MatMul_716
        onnx__MatMul_736
        onnx__MatMul_737
        onnx__MatMul_738
        onnx__MatMul_758
        onnx__MatMul_759
        onnx__MatMul_760
        onnx__MatMul_780
        onnx__MatMul_781
        onnx__MatMul_782
        onnx__MatMul_802
        onnx__MatMul_803
        onnx__MatMul_804
        onnx__MatMul_824
        onnx__MatMul_825
        onnx__MatMul_826
        onnx__MatMul_846
        onnx__MatMul_847
        patch_embed_cls_toke
        x_Encoders_layer_10
        x_Encoders_layer_149
        x_Encoders_layer_160
        x_Encoders_layer_21
        x_Encoders_layer_288
        x_Encoders_layer_299
        x_Encoders_layer_427
        x_Encoders_layer_438
        x_Encoders_layer_566
        x_Encoders_layer_577
        x_Encoders_layer_705
        x_Encoders_layer_716
        x_norm_Constant_outp
    end
    
    properties
        ONNXParams         % An ONNXParameters object containing parameters used by this layer.
    end
    
    methods
        function this = Mul_To_GemmLayer1304(name, onnxParams)
            this.Name = name;
            this.OutputNames = {'output'};
            this.ONNXParams = onnxParams;
            this.Encoders_layers_0__5 = onnxParams.Learnables.Encoders_layers_0__5;
            this.Encoders_layers_0__6 = onnxParams.Learnables.Encoders_layers_0__6;
            this.Encoders_layers_1__5 = onnxParams.Learnables.Encoders_layers_1__5;
            this.Encoders_layers_1__6 = onnxParams.Learnables.Encoders_layers_1__6;
            this.Encoders_layers_2__5 = onnxParams.Learnables.Encoders_layers_2__5;
            this.Encoders_layers_2__6 = onnxParams.Learnables.Encoders_layers_2__6;
            this.Encoders_layers_3__5 = onnxParams.Learnables.Encoders_layers_3__5;
            this.Encoders_layers_3__6 = onnxParams.Learnables.Encoders_layers_3__6;
            this.Encoders_layers_4__5 = onnxParams.Learnables.Encoders_layers_4__5;
            this.Encoders_layers_4__6 = onnxParams.Learnables.Encoders_layers_4__6;
            this.Encoders_layers_5__5 = onnxParams.Learnables.Encoders_layers_5__5;
            this.Encoders_layers_5__6 = onnxParams.Learnables.Encoders_layers_5__6;
            this.head_bias = onnxParams.Learnables.head_bias;
            this.head_weight = onnxParams.Learnables.head_weight;
            this.onnx__MatMul_716 = onnxParams.Learnables.onnx__MatMul_716;
            this.onnx__MatMul_736 = onnxParams.Learnables.onnx__MatMul_736;
            this.onnx__MatMul_737 = onnxParams.Learnables.onnx__MatMul_737;
            this.onnx__MatMul_738 = onnxParams.Learnables.onnx__MatMul_738;
            this.onnx__MatMul_758 = onnxParams.Learnables.onnx__MatMul_758;
            this.onnx__MatMul_759 = onnxParams.Learnables.onnx__MatMul_759;
            this.onnx__MatMul_760 = onnxParams.Learnables.onnx__MatMul_760;
            this.onnx__MatMul_780 = onnxParams.Learnables.onnx__MatMul_780;
            this.onnx__MatMul_781 = onnxParams.Learnables.onnx__MatMul_781;
            this.onnx__MatMul_782 = onnxParams.Learnables.onnx__MatMul_782;
            this.onnx__MatMul_802 = onnxParams.Learnables.onnx__MatMul_802;
            this.onnx__MatMul_803 = onnxParams.Learnables.onnx__MatMul_803;
            this.onnx__MatMul_804 = onnxParams.Learnables.onnx__MatMul_804;
            this.onnx__MatMul_824 = onnxParams.Learnables.onnx__MatMul_824;
            this.onnx__MatMul_825 = onnxParams.Learnables.onnx__MatMul_825;
            this.onnx__MatMul_826 = onnxParams.Learnables.onnx__MatMul_826;
            this.onnx__MatMul_846 = onnxParams.Learnables.onnx__MatMul_846;
            this.onnx__MatMul_847 = onnxParams.Learnables.onnx__MatMul_847;
            this.patch_embed_cls_toke = onnxParams.Learnables.patch_embed_cls_toke;
            this.x_Encoders_layer_10 = onnxParams.Learnables.x_Encoders_layer_10;
            this.x_Encoders_layer_149 = onnxParams.Learnables.x_Encoders_layer_149;
            this.x_Encoders_layer_160 = onnxParams.Learnables.x_Encoders_layer_160;
            this.x_Encoders_layer_21 = onnxParams.Learnables.x_Encoders_layer_21;
            this.x_Encoders_layer_288 = onnxParams.Learnables.x_Encoders_layer_288;
            this.x_Encoders_layer_299 = onnxParams.Learnables.x_Encoders_layer_299;
            this.x_Encoders_layer_427 = onnxParams.Learnables.x_Encoders_layer_427;
            this.x_Encoders_layer_438 = onnxParams.Learnables.x_Encoders_layer_438;
            this.x_Encoders_layer_566 = onnxParams.Learnables.x_Encoders_layer_566;
            this.x_Encoders_layer_577 = onnxParams.Learnables.x_Encoders_layer_577;
            this.x_Encoders_layer_705 = onnxParams.Learnables.x_Encoders_layer_705;
            this.x_Encoders_layer_716 = onnxParams.Learnables.x_Encoders_layer_716;
            this.x_norm_Constant_outp = onnxParams.Learnables.x_norm_Constant_outp;
        end
        
        function [output] = predict(this, x_patch_embed_proj_C)
            if isdlarray(x_patch_embed_proj_C)
                x_patch_embed_proj_C = stripdims(x_patch_embed_proj_C);
            end
            x_patch_embed_proj_CNumDims = 4;
            onnxParams = this.ONNXParams;
            onnxParams.Learnables.Encoders_layers_0__5 = this.Encoders_layers_0__5;
            onnxParams.Learnables.Encoders_layers_0__6 = this.Encoders_layers_0__6;
            onnxParams.Learnables.Encoders_layers_1__5 = this.Encoders_layers_1__5;
            onnxParams.Learnables.Encoders_layers_1__6 = this.Encoders_layers_1__6;
            onnxParams.Learnables.Encoders_layers_2__5 = this.Encoders_layers_2__5;
            onnxParams.Learnables.Encoders_layers_2__6 = this.Encoders_layers_2__6;
            onnxParams.Learnables.Encoders_layers_3__5 = this.Encoders_layers_3__5;
            onnxParams.Learnables.Encoders_layers_3__6 = this.Encoders_layers_3__6;
            onnxParams.Learnables.Encoders_layers_4__5 = this.Encoders_layers_4__5;
            onnxParams.Learnables.Encoders_layers_4__6 = this.Encoders_layers_4__6;
            onnxParams.Learnables.Encoders_layers_5__5 = this.Encoders_layers_5__5;
            onnxParams.Learnables.Encoders_layers_5__6 = this.Encoders_layers_5__6;
            onnxParams.Learnables.head_bias = this.head_bias;
            onnxParams.Learnables.head_weight = this.head_weight;
            onnxParams.Learnables.onnx__MatMul_716 = this.onnx__MatMul_716;
            onnxParams.Learnables.onnx__MatMul_736 = this.onnx__MatMul_736;
            onnxParams.Learnables.onnx__MatMul_737 = this.onnx__MatMul_737;
            onnxParams.Learnables.onnx__MatMul_738 = this.onnx__MatMul_738;
            onnxParams.Learnables.onnx__MatMul_758 = this.onnx__MatMul_758;
            onnxParams.Learnables.onnx__MatMul_759 = this.onnx__MatMul_759;
            onnxParams.Learnables.onnx__MatMul_760 = this.onnx__MatMul_760;
            onnxParams.Learnables.onnx__MatMul_780 = this.onnx__MatMul_780;
            onnxParams.Learnables.onnx__MatMul_781 = this.onnx__MatMul_781;
            onnxParams.Learnables.onnx__MatMul_782 = this.onnx__MatMul_782;
            onnxParams.Learnables.onnx__MatMul_802 = this.onnx__MatMul_802;
            onnxParams.Learnables.onnx__MatMul_803 = this.onnx__MatMul_803;
            onnxParams.Learnables.onnx__MatMul_804 = this.onnx__MatMul_804;
            onnxParams.Learnables.onnx__MatMul_824 = this.onnx__MatMul_824;
            onnxParams.Learnables.onnx__MatMul_825 = this.onnx__MatMul_825;
            onnxParams.Learnables.onnx__MatMul_826 = this.onnx__MatMul_826;
            onnxParams.Learnables.onnx__MatMul_846 = this.onnx__MatMul_846;
            onnxParams.Learnables.onnx__MatMul_847 = this.onnx__MatMul_847;
            onnxParams.Learnables.patch_embed_cls_toke = this.patch_embed_cls_toke;
            onnxParams.Learnables.x_Encoders_layer_10 = this.x_Encoders_layer_10;
            onnxParams.Learnables.x_Encoders_layer_149 = this.x_Encoders_layer_149;
            onnxParams.Learnables.x_Encoders_layer_160 = this.x_Encoders_layer_160;
            onnxParams.Learnables.x_Encoders_layer_21 = this.x_Encoders_layer_21;
            onnxParams.Learnables.x_Encoders_layer_288 = this.x_Encoders_layer_288;
            onnxParams.Learnables.x_Encoders_layer_299 = this.x_Encoders_layer_299;
            onnxParams.Learnables.x_Encoders_layer_427 = this.x_Encoders_layer_427;
            onnxParams.Learnables.x_Encoders_layer_438 = this.x_Encoders_layer_438;
            onnxParams.Learnables.x_Encoders_layer_566 = this.x_Encoders_layer_566;
            onnxParams.Learnables.x_Encoders_layer_577 = this.x_Encoders_layer_577;
            onnxParams.Learnables.x_Encoders_layer_705 = this.x_Encoders_layer_705;
            onnxParams.Learnables.x_Encoders_layer_716 = this.x_Encoders_layer_716;
            onnxParams.Learnables.x_norm_Constant_outp = this.x_norm_Constant_outp;
            [output, outputNumDims] = Mul_To_GemmFcn(x_patch_embed_proj_C, x_patch_embed_proj_CNumDims, onnxParams, 'Training', false, ...
                'InputDataPermutation', {[4 3 1 2], ['as-is']}, ...
                'OutputDataPermutation', {['as-is'], ['as-is']});
            if any(cellfun(@(A)isempty(A)||~isnumeric(A), {output}))
                fprintf('Runtime error in network. The custom layer ''%s'' output an empty or non-numeric value.\n', 'Mul_To_GemmLayer1304');
                error(message('nnet_cnn_onnx:onnx:BadCustomLayerRuntimeOutput', 'Mul_To_GemmLayer1304'));
            end
            output = dlarray(single(output), repmat('U', 1, max(2, outputNumDims)));
            if ~coder.target('MATLAB')
                output = extractdata(output);
            end
        end
        
        function [output] = forward(this, x_patch_embed_proj_C)
            if isdlarray(x_patch_embed_proj_C)
                x_patch_embed_proj_C = stripdims(x_patch_embed_proj_C);
            end
            x_patch_embed_proj_CNumDims = 4;
            onnxParams = this.ONNXParams;
            onnxParams.Learnables.Encoders_layers_0__5 = this.Encoders_layers_0__5;
            onnxParams.Learnables.Encoders_layers_0__6 = this.Encoders_layers_0__6;
            onnxParams.Learnables.Encoders_layers_1__5 = this.Encoders_layers_1__5;
            onnxParams.Learnables.Encoders_layers_1__6 = this.Encoders_layers_1__6;
            onnxParams.Learnables.Encoders_layers_2__5 = this.Encoders_layers_2__5;
            onnxParams.Learnables.Encoders_layers_2__6 = this.Encoders_layers_2__6;
            onnxParams.Learnables.Encoders_layers_3__5 = this.Encoders_layers_3__5;
            onnxParams.Learnables.Encoders_layers_3__6 = this.Encoders_layers_3__6;
            onnxParams.Learnables.Encoders_layers_4__5 = this.Encoders_layers_4__5;
            onnxParams.Learnables.Encoders_layers_4__6 = this.Encoders_layers_4__6;
            onnxParams.Learnables.Encoders_layers_5__5 = this.Encoders_layers_5__5;
            onnxParams.Learnables.Encoders_layers_5__6 = this.Encoders_layers_5__6;
            onnxParams.Learnables.head_bias = this.head_bias;
            onnxParams.Learnables.head_weight = this.head_weight;
            onnxParams.Learnables.onnx__MatMul_716 = this.onnx__MatMul_716;
            onnxParams.Learnables.onnx__MatMul_736 = this.onnx__MatMul_736;
            onnxParams.Learnables.onnx__MatMul_737 = this.onnx__MatMul_737;
            onnxParams.Learnables.onnx__MatMul_738 = this.onnx__MatMul_738;
            onnxParams.Learnables.onnx__MatMul_758 = this.onnx__MatMul_758;
            onnxParams.Learnables.onnx__MatMul_759 = this.onnx__MatMul_759;
            onnxParams.Learnables.onnx__MatMul_760 = this.onnx__MatMul_760;
            onnxParams.Learnables.onnx__MatMul_780 = this.onnx__MatMul_780;
            onnxParams.Learnables.onnx__MatMul_781 = this.onnx__MatMul_781;
            onnxParams.Learnables.onnx__MatMul_782 = this.onnx__MatMul_782;
            onnxParams.Learnables.onnx__MatMul_802 = this.onnx__MatMul_802;
            onnxParams.Learnables.onnx__MatMul_803 = this.onnx__MatMul_803;
            onnxParams.Learnables.onnx__MatMul_804 = this.onnx__MatMul_804;
            onnxParams.Learnables.onnx__MatMul_824 = this.onnx__MatMul_824;
            onnxParams.Learnables.onnx__MatMul_825 = this.onnx__MatMul_825;
            onnxParams.Learnables.onnx__MatMul_826 = this.onnx__MatMul_826;
            onnxParams.Learnables.onnx__MatMul_846 = this.onnx__MatMul_846;
            onnxParams.Learnables.onnx__MatMul_847 = this.onnx__MatMul_847;
            onnxParams.Learnables.patch_embed_cls_toke = this.patch_embed_cls_toke;
            onnxParams.Learnables.x_Encoders_layer_10 = this.x_Encoders_layer_10;
            onnxParams.Learnables.x_Encoders_layer_149 = this.x_Encoders_layer_149;
            onnxParams.Learnables.x_Encoders_layer_160 = this.x_Encoders_layer_160;
            onnxParams.Learnables.x_Encoders_layer_21 = this.x_Encoders_layer_21;
            onnxParams.Learnables.x_Encoders_layer_288 = this.x_Encoders_layer_288;
            onnxParams.Learnables.x_Encoders_layer_299 = this.x_Encoders_layer_299;
            onnxParams.Learnables.x_Encoders_layer_427 = this.x_Encoders_layer_427;
            onnxParams.Learnables.x_Encoders_layer_438 = this.x_Encoders_layer_438;
            onnxParams.Learnables.x_Encoders_layer_566 = this.x_Encoders_layer_566;
            onnxParams.Learnables.x_Encoders_layer_577 = this.x_Encoders_layer_577;
            onnxParams.Learnables.x_Encoders_layer_705 = this.x_Encoders_layer_705;
            onnxParams.Learnables.x_Encoders_layer_716 = this.x_Encoders_layer_716;
            onnxParams.Learnables.x_norm_Constant_outp = this.x_norm_Constant_outp;
            [output, outputNumDims] = Mul_To_GemmFcn(x_patch_embed_proj_C, x_patch_embed_proj_CNumDims, onnxParams, 'Training', true, ...
                'InputDataPermutation', {[4 3 1 2], ['as-is']}, ...
                'OutputDataPermutation', {['as-is'], ['as-is']});
            if any(cellfun(@(A)isempty(A)||~isnumeric(A), {output}))
                fprintf('Runtime error in network. The custom layer ''%s'' output an empty or non-numeric value.\n', 'Mul_To_GemmLayer1304');
                error(message('nnet_cnn_onnx:onnx:BadCustomLayerRuntimeOutput', 'Mul_To_GemmLayer1304'));
            end
            output = dlarray(single(output), repmat('U', 1, max(2, outputNumDims)));
            if ~coder.target('MATLAB')
                output = extractdata(output);
            end
        end
    end
end

function [output, outputNumDims, state] = Mul_To_GemmFcn(x_patch_embed_proj_C, x_patch_embed_proj_CNumDims, params, varargin)
%MUL_TO_GEMMFCN Function implementing an imported ONNX network.
%
% THIS FILE WAS AUTO-GENERATED BY importONNXFunction.
% ONNX Operator Set Version: 11
%
% Variable names in this function are taken from the original ONNX file.
%
% [OUTPUT] = Mul_To_GemmFcn(X_PATCH_EMBED_PROJ_C, PARAMS)
%			- Evaluates the imported ONNX network MUL_TO_GEMMFCN with input(s)
%			X_PATCH_EMBED_PROJ_C and the imported network parameters in PARAMS. Returns
%			network output(s) in OUTPUT.
%
% [OUTPUT, STATE] = Mul_To_GemmFcn(X_PATCH_EMBED_PROJ_C, PARAMS)
%			- Additionally returns state variables in STATE. When training,
%			use this form and set TRAINING to true.
%
% [__] = Mul_To_GemmFcn(X_PATCH_EMBED_PROJ_C, PARAMS, 'NAME1', VAL1, 'NAME2', VAL2, ...)
%			- Specifies additional name-value pairs described below:
%
% 'Training'
% 			Boolean indicating whether the network is being evaluated for
%			prediction or training. If TRAINING is true, state variables
%			will be updated.
%
% 'InputDataPermutation'
%			'auto' - Automatically attempt to determine the permutation
%			 between the dimensions of the input data and the dimensions of
%			the ONNX model input. For example, the permutation from HWCN
%			(MATLAB standard) to NCHW (ONNX standard) uses the vector
%			[4 3 1 2]. See the documentation for IMPORTONNXFUNCTION for
%			more information about automatic permutation.
%
%			'none' - Input(s) are passed in the ONNX model format. See 'Inputs'.
%
%			numeric vector - The permutation vector describing the
%			transformation between input data dimensions and the expected
%			ONNX input dimensions.%
%			cell array - If the network has multiple inputs, each cell
%			contains 'auto', 'none', or a numeric vector.
%
% 'OutputDataPermutation'
%			'auto' - Automatically attempt to determine the permutation
%			between the dimensions of the output and a conventional MATLAB
%			dimension ordering. For example, the permutation from NC (ONNX
%			standard) to CN (MATLAB standard) uses the vector [2 1]. See
%			the documentation for IMPORTONNXFUNCTION for more information
%			about automatic permutation.
%
%			'none' - Return output(s) as given by the ONNX model. See 'Outputs'.
%
%			numeric vector - The permutation vector describing the
%			transformation between the ONNX output dimensions and the
%			desired output dimensions.%
%			cell array - If the network has multiple outputs, each cell
%			contains 'auto', 'none' or a numeric vector.
%
% Inputs:
% -------
% X_PATCH_EMBED_PROJ_C
%			- Input(s) to the ONNX network.
%			  The input size(s) expected by the ONNX file are:
%				  X_PATCH_EMBED_PROJ_C:		[Unknown, Unknown, Unknown, Unknown]				Type: FLOAT
%			  By default, the function will try to permute the input(s)
%			  into this dimension ordering. If the default is incorrect,
%			  use the 'InputDataPermutation' argument to control the
%			  permutation.
%
%
% PARAMS	- Network parameters returned by 'importONNXFunction'.
%
%
% Outputs:
% --------
% OUTPUT
%			- Output(s) of the ONNX network.
%			  Without permutation, the size(s) of the outputs are:
%				  OUTPUT:		[1, 3]				Type: FLOAT
%			  By default, the function will try to permute the output(s)
%			  from this dimension ordering into a conventional MATLAB
%			  ordering. If the default is incorrect, use the
%			  'OutputDataPermutation' argument to control the permutation.
%
% STATE		- (Optional) State variables. When TRAINING is true, these will
% 			  have been updated from the original values in PARAMS.State.
%
%
%  See also importONNXFunction

% Preprocess the input data and arguments:
[x_patch_embed_proj_C, Training, outputDataPerms, anyDlarrayInputs] = preprocessInput(x_patch_embed_proj_C, params, varargin{:});
% Put all variables into a single struct to implement dynamic scoping:
[Vars, NumDims] = packageVariables(params, {'x_patch_embed_proj_C'}, {x_patch_embed_proj_C}, [x_patch_embed_proj_CNumDims]);
% Call the top-level graph function:
[output, outputNumDims, state] = Mul_To_GemmGraph1224(x_patch_embed_proj_C, NumDims.x_patch_embed_proj_C, Vars, NumDims, Training, params.State);
% Postprocess the output data
[output] = postprocessOutput(output, outputDataPerms, anyDlarrayInputs, Training, varargin{:});
end

function [output, outputNumDims1303, state] = Mul_To_GemmGraph1224(x_patch_embed_proj_C, x_patch_embed_proj_CNumDims1302, Vars, NumDims, Training, state)
% Function implementing the graph 'Mul_To_GemmGraph1224'
% Update Vars and NumDims from the graph's formal input parameters. Note that state variables are already in Vars.
Vars.x_patch_embed_proj_C = x_patch_embed_proj_C;
NumDims.x_patch_embed_proj_C = x_patch_embed_proj_CNumDims1302;

% Execute the operators:
% Shape:
[Vars.x_patch_embed_Shape_, NumDims.x_patch_embed_Shape_] = onnxShape(Vars.x_patch_embed_proj_C, NumDims.x_patch_embed_proj_C);

% Slice:
[Indices, NumDims.x_patch_embed_Slice_] = prepareSliceArgs(Vars.x_patch_embed_Shape_, Vars.x_patch_embed_Con_2, Vars.x_patch_embed_Con_3, Vars.x_patch_embed_Con_1, '', NumDims.x_patch_embed_Shape_);
Vars.x_patch_embed_Slice_ = subsref(Vars.x_patch_embed_Shape_, Indices);

% Concat:
[Vars.x_patch_embed_Conc_1, NumDims.x_patch_embed_Conc_1] = onnxConcat(0, {Vars.x_patch_embed_Slice_, Vars.x_patch_embed_Con_4}, [NumDims.x_patch_embed_Slice_, NumDims.x_patch_embed_Con_4]);

% Reshape:
[shape, NumDims.x_patch_embed_Reshap] = prepareReshapeArgs(Vars.x_patch_embed_proj_C, Vars.x_patch_embed_Conc_1, NumDims.x_patch_embed_proj_C, 0);
Vars.x_patch_embed_Reshap = reshape(Vars.x_patch_embed_proj_C, shape{:});

% Transpose:
[perm, NumDims.x_patch_embed_Transp] = prepareTransposeArgs(Vars.TransposePerm1225, NumDims.x_patch_embed_Reshap);
if ~isempty(perm)
    Vars.x_patch_embed_Transp = permute(Vars.x_patch_embed_Reshap, perm);
end

% Mul:
Vars.x_patch_embed_Mul_ou = Vars.x_patch_embed_Consta .* Vars.x_patch_embed_Con_7;
NumDims.x_patch_embed_Mul_ou = max(NumDims.x_patch_embed_Consta, NumDims.x_patch_embed_Con_7);

% Equal:
Vars.x_patch_embed_Equal_ = Vars.x_patch_embed_Con_5 == Vars.x_patch_embed_Mul_ou;
NumDims.x_patch_embed_Equal_ = max(NumDims.x_patch_embed_Con_5, NumDims.x_patch_embed_Mul_ou);

% Where:
[Vars.x_patch_embed_Where_, NumDims.x_patch_embed_Where_] = onnxWhere(Vars.x_patch_embed_Equal_, Vars.x_patch_embed_Consta, Vars.x_patch_embed_Con_5, NumDims.x_patch_embed_Equal_, NumDims.x_patch_embed_Consta, NumDims.x_patch_embed_Con_5);

% Expand:
[shape, NumDims.x_patch_embed_Expand] = prepareExpandArgs(Vars.x_patch_embed_Where_);
Vars.x_patch_embed_Expand = Vars.patch_embed_cls_toke + zeros(shape);

% Concat:
[Vars.x_patch_embed_Concat, NumDims.x_patch_embed_Concat] = onnxConcat(1, {Vars.x_patch_embed_Expand, Vars.x_patch_embed_Transp}, [NumDims.x_patch_embed_Expand, NumDims.x_patch_embed_Transp]);

% Add:
Vars.x_patch_embed_Add_ou = Vars.x_patch_embed_Concat + Vars.patch_embed_pos_embe;
NumDims.x_patch_embed_Add_ou = max(NumDims.x_patch_embed_Concat, NumDims.patch_embed_pos_embe);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1226, NumDims.x_patch_embed_Add_ou);
Vars.x_Encoders_layer_15 = mean(Vars.x_patch_embed_Add_ou, dims);
NumDims.x_Encoders_layer_15 = NumDims.x_patch_embed_Add_ou;

% Sub:
Vars.x_Encoders_layer_17 = Vars.x_patch_embed_Add_ou - Vars.x_Encoders_layer_15;
NumDims.x_Encoders_layer_17 = max(NumDims.x_patch_embed_Add_ou, NumDims.x_Encoders_layer_15);

% Pow:
Vars.x_Encoders_layer_13 = power(Vars.x_Encoders_layer_17, Vars.x_Encoders_layer_10);
NumDims.x_Encoders_layer_13 = max(NumDims.x_Encoders_layer_17, NumDims.x_Encoders_layer_10);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1227, NumDims.x_Encoders_layer_13);
Vars.x_Encoders_layer_14 = mean(Vars.x_Encoders_layer_13, dims);
NumDims.x_Encoders_layer_14 = NumDims.x_Encoders_layer_13;

% Add:
Vars.x_Encoders_layer_8 = Vars.x_Encoders_layer_14 + Vars.x_Encoders_layer_9;
NumDims.x_Encoders_layer_8 = max(NumDims.x_Encoders_layer_14, NumDims.x_Encoders_layer_9);

% Sqrt:
Vars.x_Encoders_layer_16 = sqrt(Vars.x_Encoders_layer_8);
NumDims.x_Encoders_layer_16 = NumDims.x_Encoders_layer_8;

% Div:
Vars.x_Encoders_layer_11 = Vars.x_Encoders_layer_17 ./ Vars.x_Encoders_layer_16;
NumDims.x_Encoders_layer_11 = max(NumDims.x_Encoders_layer_17, NumDims.x_Encoders_layer_16);

% Mul:
Vars.x_Encoders_layer_12 = Vars.x_Encoders_layer_11 .* Vars.Encoders_layers_0__2;
NumDims.x_Encoders_layer_12 = max(NumDims.x_Encoders_layer_11, NumDims.Encoders_layers_0__2);

% Add:
Vars.x_Encoders_layer_7 = Vars.x_Encoders_layer_12 + Vars.Encoders_layers_0_no;
NumDims.x_Encoders_layer_7 = max(NumDims.x_Encoders_layer_12, NumDims.Encoders_layers_0_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_69] = prepareTransposeArgs(Vars.TransposePerm1228, NumDims.x_Encoders_layer_7);
if ~isempty(perm)
    Vars.x_Encoders_layer_69 = permute(Vars.x_Encoders_layer_7, perm);
end

% MatMul:
[Vars.x_Encoders_layer_50, NumDims.x_Encoders_layer_50] = onnxMatMul(Vars.x_Encoders_layer_69, Vars.onnx__MatMul_716, NumDims.x_Encoders_layer_69, NumDims.onnx__MatMul_716);

% Add:
Vars.x_Encoders_layer_30 = Vars.Encoders_layers_0_se + Vars.x_Encoders_layer_50;
NumDims.x_Encoders_layer_30 = max(NumDims.Encoders_layers_0_se, NumDims.x_Encoders_layer_50);

% Shape:
[Vars.x_Encoders_layer_59, NumDims.x_Encoders_layer_59] = onnxShape(Vars.x_Encoders_layer_30, NumDims.x_Encoders_layer_30);

% Gather:
[Vars.x_Encoders_layer_46, NumDims.x_Encoders_layer_46] = onnxGather(Vars.x_Encoders_layer_59, Vars.x_Encoders_layer_43, 0, NumDims.x_Encoders_layer_59, NumDims.x_Encoders_layer_43);

% Add:
Vars.x_Encoders_layer_29 = Vars.x_Encoders_layer_46 + Vars.x_Encoders_layer_35;
NumDims.x_Encoders_layer_29 = max(NumDims.x_Encoders_layer_46, NumDims.x_Encoders_layer_35);

% Div:
Vars.x_Encoders_layer_45 = fix(Vars.x_Encoders_layer_29 ./ Vars.x_Encoders_layer_36);
NumDims.x_Encoders_layer_45 = max(NumDims.x_Encoders_layer_29, NumDims.x_Encoders_layer_36);

% Mul:
Vars.x_Encoders_layer_53 = Vars.x_Encoders_layer_45 .* Vars.x_Encoders_layer_37;
NumDims.x_Encoders_layer_53 = max(NumDims.x_Encoders_layer_45, NumDims.x_Encoders_layer_37);

% Slice:
[Indices, NumDims.x_Encoders_layer_62] = prepareSliceArgs(Vars.x_Encoders_layer_30, Vars.x_Encoders_layer_34, Vars.x_Encoders_layer_53, Vars.x_Encoders_layer_43, '', NumDims.x_Encoders_layer_30);
Vars.x_Encoders_layer_62 = subsref(Vars.x_Encoders_layer_30, Indices);

% Mul:
Vars.x_Encoders_layer_51 = Vars.x_Encoders_layer_45 .* Vars.x_Encoders_layer_38;
NumDims.x_Encoders_layer_51 = max(NumDims.x_Encoders_layer_45, NumDims.x_Encoders_layer_38);

% Slice:
[Indices, NumDims.x_Encoders_layer_60] = prepareSliceArgs(Vars.x_Encoders_layer_30, Vars.x_Encoders_layer_53, Vars.x_Encoders_layer_51, Vars.x_Encoders_layer_43, '', NumDims.x_Encoders_layer_30);
Vars.x_Encoders_layer_60 = subsref(Vars.x_Encoders_layer_30, Indices);

% Mul:
Vars.x_Encoders_layer_52 = Vars.x_Encoders_layer_45 .* Vars.x_Encoders_layer_39;
NumDims.x_Encoders_layer_52 = max(NumDims.x_Encoders_layer_45, NumDims.x_Encoders_layer_39);

% Slice:
[Indices, NumDims.x_Encoders_layer_61] = prepareSliceArgs(Vars.x_Encoders_layer_30, Vars.x_Encoders_layer_51, Vars.x_Encoders_layer_52, Vars.x_Encoders_layer_43, '', NumDims.x_Encoders_layer_30);
Vars.x_Encoders_layer_61 = subsref(Vars.x_Encoders_layer_30, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_58] = prepareReshapeArgs(Vars.x_Encoders_layer_62, Vars.x_Encoders_layer_40, NumDims.x_Encoders_layer_62, 0);
Vars.x_Encoders_layer_58 = reshape(Vars.x_Encoders_layer_62, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_64] = prepareTransposeArgs(Vars.TransposePerm1229, NumDims.x_Encoders_layer_58);
if ~isempty(perm)
    Vars.x_Encoders_layer_64 = permute(Vars.x_Encoders_layer_58, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_54] = prepareReshapeArgs(Vars.x_Encoders_layer_60, Vars.x_Encoders_layer_41, NumDims.x_Encoders_layer_60, 0);
Vars.x_Encoders_layer_54 = reshape(Vars.x_Encoders_layer_60, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_55] = prepareReshapeArgs(Vars.x_Encoders_layer_61, Vars.x_Encoders_layer_42, NumDims.x_Encoders_layer_61, 0);
Vars.x_Encoders_layer_55 = reshape(Vars.x_Encoders_layer_61, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_65] = prepareTransposeArgs(Vars.TransposePerm1230, NumDims.x_Encoders_layer_55);
if ~isempty(perm)
    Vars.x_Encoders_layer_65 = permute(Vars.x_Encoders_layer_55, perm);
end

% Div:
Vars.x_Encoders_layer_44 = Vars.x_Encoders_layer_64 ./ Vars.x_Encoders_layer_31;
NumDims.x_Encoders_layer_44 = max(NumDims.x_Encoders_layer_64, NumDims.x_Encoders_layer_31);

% Transpose:
[perm, NumDims.x_Encoders_layer_66] = prepareTransposeArgs(Vars.TransposePerm1231, NumDims.x_Encoders_layer_54);
if ~isempty(perm)
    Vars.x_Encoders_layer_66 = permute(Vars.x_Encoders_layer_54, perm);
end

% MatMul:
[Vars.x_Encoders_layer_48, NumDims.x_Encoders_layer_48] = onnxMatMul(Vars.x_Encoders_layer_44, Vars.x_Encoders_layer_66, NumDims.x_Encoders_layer_44, NumDims.x_Encoders_layer_66);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_63] = prepareSoftmaxArgs(Vars.x_Encoders_layer_48, 2, NumDims.x_Encoders_layer_48);
Vars.x_Encoders_layer_63 = reshape(Vars.x_Encoders_layer_48, dim1, dim2);
Vars.x_Encoders_layer_63 = softmax(Vars.x_Encoders_layer_63, 'DataFormat', 'CB');
Vars.x_Encoders_layer_63 = reshape(Vars.x_Encoders_layer_63, origSize);

% MatMul:
[Vars.x_Encoders_layer_49, NumDims.x_Encoders_layer_49] = onnxMatMul(Vars.x_Encoders_layer_63, Vars.x_Encoders_layer_65, NumDims.x_Encoders_layer_63, NumDims.x_Encoders_layer_65);

% Transpose:
[perm, NumDims.x_Encoders_layer_67] = prepareTransposeArgs(Vars.TransposePerm1232, NumDims.x_Encoders_layer_49);
if ~isempty(perm)
    Vars.x_Encoders_layer_67 = permute(Vars.x_Encoders_layer_49, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_56] = prepareReshapeArgs(Vars.x_Encoders_layer_67, Vars.x_Encoders_layer_32, NumDims.x_Encoders_layer_67, 0);
Vars.x_Encoders_layer_56 = reshape(Vars.x_Encoders_layer_67, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_47] = prepareGemmArgs(Vars.x_Encoders_layer_56, Vars.Encoders_layers_0__6, Vars.Encoders_layers_0__5, Vars.Gemmalpha1233, Vars.Gemmbeta1234, 0, 1, NumDims.Encoders_layers_0__5);
Vars.x_Encoders_layer_47 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_57] = prepareReshapeArgs(Vars.x_Encoders_layer_47, Vars.x_Encoders_layer_33, NumDims.x_Encoders_layer_47, 0);
Vars.x_Encoders_layer_57 = reshape(Vars.x_Encoders_layer_47, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_68] = prepareTransposeArgs(Vars.TransposePerm1235, NumDims.x_Encoders_layer_57);
if ~isempty(perm)
    Vars.x_Encoders_layer_68 = permute(Vars.x_Encoders_layer_57, perm);
end

% Add:
Vars.x_Encoders_layer_1 = Vars.x_patch_embed_Add_ou + Vars.x_Encoders_layer_68;
NumDims.x_Encoders_layer_1 = max(NumDims.x_patch_embed_Add_ou, NumDims.x_Encoders_layer_68);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1236, NumDims.x_Encoders_layer_1);
Vars.x_Encoders_layer_26 = mean(Vars.x_Encoders_layer_1, dims);
NumDims.x_Encoders_layer_26 = NumDims.x_Encoders_layer_1;

% Sub:
Vars.x_Encoders_layer_28 = Vars.x_Encoders_layer_1 - Vars.x_Encoders_layer_26;
NumDims.x_Encoders_layer_28 = max(NumDims.x_Encoders_layer_1, NumDims.x_Encoders_layer_26);

% Pow:
Vars.x_Encoders_layer_24 = power(Vars.x_Encoders_layer_28, Vars.x_Encoders_layer_21);
NumDims.x_Encoders_layer_24 = max(NumDims.x_Encoders_layer_28, NumDims.x_Encoders_layer_21);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1237, NumDims.x_Encoders_layer_24);
Vars.x_Encoders_layer_25 = mean(Vars.x_Encoders_layer_24, dims);
NumDims.x_Encoders_layer_25 = NumDims.x_Encoders_layer_24;

% Add:
Vars.x_Encoders_layer_19 = Vars.x_Encoders_layer_25 + Vars.x_Encoders_layer_20;
NumDims.x_Encoders_layer_19 = max(NumDims.x_Encoders_layer_25, NumDims.x_Encoders_layer_20);

% Sqrt:
Vars.x_Encoders_layer_27 = sqrt(Vars.x_Encoders_layer_19);
NumDims.x_Encoders_layer_27 = NumDims.x_Encoders_layer_19;

% Div:
Vars.x_Encoders_layer_22 = Vars.x_Encoders_layer_28 ./ Vars.x_Encoders_layer_27;
NumDims.x_Encoders_layer_22 = max(NumDims.x_Encoders_layer_28, NumDims.x_Encoders_layer_27);

% Mul:
Vars.x_Encoders_layer_23 = Vars.x_Encoders_layer_22 .* Vars.Encoders_layers_0__4;
NumDims.x_Encoders_layer_23 = max(NumDims.x_Encoders_layer_22, NumDims.Encoders_layers_0__4);

% Add:
Vars.x_Encoders_layer_18 = Vars.x_Encoders_layer_23 + Vars.Encoders_layers_0__3;
NumDims.x_Encoders_layer_18 = max(NumDims.x_Encoders_layer_23, NumDims.Encoders_layers_0__3);

% MatMul:
[Vars.x_Encoders_layer_4, NumDims.x_Encoders_layer_4] = onnxMatMul(Vars.x_Encoders_layer_18, Vars.onnx__MatMul_736, NumDims.x_Encoders_layer_18, NumDims.onnx__MatMul_736);

% Add:
Vars.x_Encoders_layer_3 = Vars.Encoders_layers_0_li + Vars.x_Encoders_layer_4;
NumDims.x_Encoders_layer_3 = max(NumDims.Encoders_layers_0_li, NumDims.x_Encoders_layer_4);

% Relu:
Vars.x_Encoders_layer_2 = relu(Vars.x_Encoders_layer_3);
NumDims.x_Encoders_layer_2 = NumDims.x_Encoders_layer_3;

% MatMul:
[Vars.x_Encoders_layer_6, NumDims.x_Encoders_layer_6] = onnxMatMul(Vars.x_Encoders_layer_2, Vars.onnx__MatMul_737, NumDims.x_Encoders_layer_2, NumDims.onnx__MatMul_737);

% Add:
Vars.x_Encoders_layer_5 = Vars.Encoders_layers_0__1 + Vars.x_Encoders_layer_6;
NumDims.x_Encoders_layer_5 = max(NumDims.Encoders_layers_0__1, NumDims.x_Encoders_layer_6);

% Add:
Vars.x_Encoders_layers_0_ = Vars.x_Encoders_layer_1 + Vars.x_Encoders_layer_5;
NumDims.x_Encoders_layers_0_ = max(NumDims.x_Encoders_layer_1, NumDims.x_Encoders_layer_5);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1238, NumDims.x_Encoders_layers_0_);
Vars.x_Encoders_layer_154 = mean(Vars.x_Encoders_layers_0_, dims);
NumDims.x_Encoders_layer_154 = NumDims.x_Encoders_layers_0_;

% Sub:
Vars.x_Encoders_layer_156 = Vars.x_Encoders_layers_0_ - Vars.x_Encoders_layer_154;
NumDims.x_Encoders_layer_156 = max(NumDims.x_Encoders_layers_0_, NumDims.x_Encoders_layer_154);

% Pow:
Vars.x_Encoders_layer_152 = power(Vars.x_Encoders_layer_156, Vars.x_Encoders_layer_149);
NumDims.x_Encoders_layer_152 = max(NumDims.x_Encoders_layer_156, NumDims.x_Encoders_layer_149);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1239, NumDims.x_Encoders_layer_152);
Vars.x_Encoders_layer_153 = mean(Vars.x_Encoders_layer_152, dims);
NumDims.x_Encoders_layer_153 = NumDims.x_Encoders_layer_152;

% Add:
Vars.x_Encoders_layer_147 = Vars.x_Encoders_layer_153 + Vars.x_Encoders_layer_148;
NumDims.x_Encoders_layer_147 = max(NumDims.x_Encoders_layer_153, NumDims.x_Encoders_layer_148);

% Sqrt:
Vars.x_Encoders_layer_155 = sqrt(Vars.x_Encoders_layer_147);
NumDims.x_Encoders_layer_155 = NumDims.x_Encoders_layer_147;

% Div:
Vars.x_Encoders_layer_150 = Vars.x_Encoders_layer_156 ./ Vars.x_Encoders_layer_155;
NumDims.x_Encoders_layer_150 = max(NumDims.x_Encoders_layer_156, NumDims.x_Encoders_layer_155);

% Mul:
Vars.x_Encoders_layer_151 = Vars.x_Encoders_layer_150 .* Vars.Encoders_layers_1__2;
NumDims.x_Encoders_layer_151 = max(NumDims.x_Encoders_layer_150, NumDims.Encoders_layers_1__2);

% Add:
Vars.x_Encoders_layer_146 = Vars.x_Encoders_layer_151 + Vars.Encoders_layers_1_no;
NumDims.x_Encoders_layer_146 = max(NumDims.x_Encoders_layer_151, NumDims.Encoders_layers_1_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_208] = prepareTransposeArgs(Vars.TransposePerm1240, NumDims.x_Encoders_layer_146);
if ~isempty(perm)
    Vars.x_Encoders_layer_208 = permute(Vars.x_Encoders_layer_146, perm);
end

% MatMul:
[Vars.x_Encoders_layer_189, NumDims.x_Encoders_layer_189] = onnxMatMul(Vars.x_Encoders_layer_208, Vars.onnx__MatMul_738, NumDims.x_Encoders_layer_208, NumDims.onnx__MatMul_738);

% Add:
Vars.x_Encoders_layer_169 = Vars.Encoders_layers_1_se + Vars.x_Encoders_layer_189;
NumDims.x_Encoders_layer_169 = max(NumDims.Encoders_layers_1_se, NumDims.x_Encoders_layer_189);

% Shape:
[Vars.x_Encoders_layer_198, NumDims.x_Encoders_layer_198] = onnxShape(Vars.x_Encoders_layer_169, NumDims.x_Encoders_layer_169);

% Gather:
[Vars.x_Encoders_layer_185, NumDims.x_Encoders_layer_185] = onnxGather(Vars.x_Encoders_layer_198, Vars.x_Encoders_layer_182, 0, NumDims.x_Encoders_layer_198, NumDims.x_Encoders_layer_182);

% Add:
Vars.x_Encoders_layer_168 = Vars.x_Encoders_layer_185 + Vars.x_Encoders_layer_174;
NumDims.x_Encoders_layer_168 = max(NumDims.x_Encoders_layer_185, NumDims.x_Encoders_layer_174);

% Div:
Vars.x_Encoders_layer_184 = fix(Vars.x_Encoders_layer_168 ./ Vars.x_Encoders_layer_175);
NumDims.x_Encoders_layer_184 = max(NumDims.x_Encoders_layer_168, NumDims.x_Encoders_layer_175);

% Mul:
Vars.x_Encoders_layer_192 = Vars.x_Encoders_layer_184 .* Vars.x_Encoders_layer_176;
NumDims.x_Encoders_layer_192 = max(NumDims.x_Encoders_layer_184, NumDims.x_Encoders_layer_176);

% Slice:
[Indices, NumDims.x_Encoders_layer_201] = prepareSliceArgs(Vars.x_Encoders_layer_169, Vars.x_Encoders_layer_173, Vars.x_Encoders_layer_192, Vars.x_Encoders_layer_182, '', NumDims.x_Encoders_layer_169);
Vars.x_Encoders_layer_201 = subsref(Vars.x_Encoders_layer_169, Indices);

% Mul:
Vars.x_Encoders_layer_190 = Vars.x_Encoders_layer_184 .* Vars.x_Encoders_layer_177;
NumDims.x_Encoders_layer_190 = max(NumDims.x_Encoders_layer_184, NumDims.x_Encoders_layer_177);

% Slice:
[Indices, NumDims.x_Encoders_layer_199] = prepareSliceArgs(Vars.x_Encoders_layer_169, Vars.x_Encoders_layer_192, Vars.x_Encoders_layer_190, Vars.x_Encoders_layer_182, '', NumDims.x_Encoders_layer_169);
Vars.x_Encoders_layer_199 = subsref(Vars.x_Encoders_layer_169, Indices);

% Mul:
Vars.x_Encoders_layer_191 = Vars.x_Encoders_layer_184 .* Vars.x_Encoders_layer_178;
NumDims.x_Encoders_layer_191 = max(NumDims.x_Encoders_layer_184, NumDims.x_Encoders_layer_178);

% Slice:
[Indices, NumDims.x_Encoders_layer_200] = prepareSliceArgs(Vars.x_Encoders_layer_169, Vars.x_Encoders_layer_190, Vars.x_Encoders_layer_191, Vars.x_Encoders_layer_182, '', NumDims.x_Encoders_layer_169);
Vars.x_Encoders_layer_200 = subsref(Vars.x_Encoders_layer_169, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_197] = prepareReshapeArgs(Vars.x_Encoders_layer_201, Vars.x_Encoders_layer_179, NumDims.x_Encoders_layer_201, 0);
Vars.x_Encoders_layer_197 = reshape(Vars.x_Encoders_layer_201, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_203] = prepareTransposeArgs(Vars.TransposePerm1241, NumDims.x_Encoders_layer_197);
if ~isempty(perm)
    Vars.x_Encoders_layer_203 = permute(Vars.x_Encoders_layer_197, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_193] = prepareReshapeArgs(Vars.x_Encoders_layer_199, Vars.x_Encoders_layer_180, NumDims.x_Encoders_layer_199, 0);
Vars.x_Encoders_layer_193 = reshape(Vars.x_Encoders_layer_199, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_194] = prepareReshapeArgs(Vars.x_Encoders_layer_200, Vars.x_Encoders_layer_181, NumDims.x_Encoders_layer_200, 0);
Vars.x_Encoders_layer_194 = reshape(Vars.x_Encoders_layer_200, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_204] = prepareTransposeArgs(Vars.TransposePerm1242, NumDims.x_Encoders_layer_194);
if ~isempty(perm)
    Vars.x_Encoders_layer_204 = permute(Vars.x_Encoders_layer_194, perm);
end

% Div:
Vars.x_Encoders_layer_183 = Vars.x_Encoders_layer_203 ./ Vars.x_Encoders_layer_170;
NumDims.x_Encoders_layer_183 = max(NumDims.x_Encoders_layer_203, NumDims.x_Encoders_layer_170);

% Transpose:
[perm, NumDims.x_Encoders_layer_205] = prepareTransposeArgs(Vars.TransposePerm1243, NumDims.x_Encoders_layer_193);
if ~isempty(perm)
    Vars.x_Encoders_layer_205 = permute(Vars.x_Encoders_layer_193, perm);
end

% MatMul:
[Vars.x_Encoders_layer_187, NumDims.x_Encoders_layer_187] = onnxMatMul(Vars.x_Encoders_layer_183, Vars.x_Encoders_layer_205, NumDims.x_Encoders_layer_183, NumDims.x_Encoders_layer_205);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_202] = prepareSoftmaxArgs(Vars.x_Encoders_layer_187, 2, NumDims.x_Encoders_layer_187);
Vars.x_Encoders_layer_202 = reshape(Vars.x_Encoders_layer_187, dim1, dim2);
Vars.x_Encoders_layer_202 = softmax(Vars.x_Encoders_layer_202, 'DataFormat', 'CB');
Vars.x_Encoders_layer_202 = reshape(Vars.x_Encoders_layer_202, origSize);

% MatMul:
[Vars.x_Encoders_layer_188, NumDims.x_Encoders_layer_188] = onnxMatMul(Vars.x_Encoders_layer_202, Vars.x_Encoders_layer_204, NumDims.x_Encoders_layer_202, NumDims.x_Encoders_layer_204);

% Transpose:
[perm, NumDims.x_Encoders_layer_206] = prepareTransposeArgs(Vars.TransposePerm1244, NumDims.x_Encoders_layer_188);
if ~isempty(perm)
    Vars.x_Encoders_layer_206 = permute(Vars.x_Encoders_layer_188, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_195] = prepareReshapeArgs(Vars.x_Encoders_layer_206, Vars.x_Encoders_layer_171, NumDims.x_Encoders_layer_206, 0);
Vars.x_Encoders_layer_195 = reshape(Vars.x_Encoders_layer_206, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_186] = prepareGemmArgs(Vars.x_Encoders_layer_195, Vars.Encoders_layers_1__6, Vars.Encoders_layers_1__5, Vars.Gemmalpha1245, Vars.Gemmbeta1246, 0, 1, NumDims.Encoders_layers_1__5);
Vars.x_Encoders_layer_186 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_196] = prepareReshapeArgs(Vars.x_Encoders_layer_186, Vars.x_Encoders_layer_172, NumDims.x_Encoders_layer_186, 0);
Vars.x_Encoders_layer_196 = reshape(Vars.x_Encoders_layer_186, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_207] = prepareTransposeArgs(Vars.TransposePerm1247, NumDims.x_Encoders_layer_196);
if ~isempty(perm)
    Vars.x_Encoders_layer_207 = permute(Vars.x_Encoders_layer_196, perm);
end

% Add:
Vars.x_Encoders_layer_140 = Vars.x_Encoders_layers_0_ + Vars.x_Encoders_layer_207;
NumDims.x_Encoders_layer_140 = max(NumDims.x_Encoders_layers_0_, NumDims.x_Encoders_layer_207);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1248, NumDims.x_Encoders_layer_140);
Vars.x_Encoders_layer_165 = mean(Vars.x_Encoders_layer_140, dims);
NumDims.x_Encoders_layer_165 = NumDims.x_Encoders_layer_140;

% Sub:
Vars.x_Encoders_layer_167 = Vars.x_Encoders_layer_140 - Vars.x_Encoders_layer_165;
NumDims.x_Encoders_layer_167 = max(NumDims.x_Encoders_layer_140, NumDims.x_Encoders_layer_165);

% Pow:
Vars.x_Encoders_layer_163 = power(Vars.x_Encoders_layer_167, Vars.x_Encoders_layer_160);
NumDims.x_Encoders_layer_163 = max(NumDims.x_Encoders_layer_167, NumDims.x_Encoders_layer_160);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1249, NumDims.x_Encoders_layer_163);
Vars.x_Encoders_layer_164 = mean(Vars.x_Encoders_layer_163, dims);
NumDims.x_Encoders_layer_164 = NumDims.x_Encoders_layer_163;

% Add:
Vars.x_Encoders_layer_158 = Vars.x_Encoders_layer_164 + Vars.x_Encoders_layer_159;
NumDims.x_Encoders_layer_158 = max(NumDims.x_Encoders_layer_164, NumDims.x_Encoders_layer_159);

% Sqrt:
Vars.x_Encoders_layer_166 = sqrt(Vars.x_Encoders_layer_158);
NumDims.x_Encoders_layer_166 = NumDims.x_Encoders_layer_158;

% Div:
Vars.x_Encoders_layer_161 = Vars.x_Encoders_layer_167 ./ Vars.x_Encoders_layer_166;
NumDims.x_Encoders_layer_161 = max(NumDims.x_Encoders_layer_167, NumDims.x_Encoders_layer_166);

% Mul:
Vars.x_Encoders_layer_162 = Vars.x_Encoders_layer_161 .* Vars.Encoders_layers_1__4;
NumDims.x_Encoders_layer_162 = max(NumDims.x_Encoders_layer_161, NumDims.Encoders_layers_1__4);

% Add:
Vars.x_Encoders_layer_157 = Vars.x_Encoders_layer_162 + Vars.Encoders_layers_1__3;
NumDims.x_Encoders_layer_157 = max(NumDims.x_Encoders_layer_162, NumDims.Encoders_layers_1__3);

% MatMul:
[Vars.x_Encoders_layer_143, NumDims.x_Encoders_layer_143] = onnxMatMul(Vars.x_Encoders_layer_157, Vars.onnx__MatMul_758, NumDims.x_Encoders_layer_157, NumDims.onnx__MatMul_758);

% Add:
Vars.x_Encoders_layer_142 = Vars.Encoders_layers_1_li + Vars.x_Encoders_layer_143;
NumDims.x_Encoders_layer_142 = max(NumDims.Encoders_layers_1_li, NumDims.x_Encoders_layer_143);

% Relu:
Vars.x_Encoders_layer_141 = relu(Vars.x_Encoders_layer_142);
NumDims.x_Encoders_layer_141 = NumDims.x_Encoders_layer_142;

% MatMul:
[Vars.x_Encoders_layer_145, NumDims.x_Encoders_layer_145] = onnxMatMul(Vars.x_Encoders_layer_141, Vars.onnx__MatMul_759, NumDims.x_Encoders_layer_141, NumDims.onnx__MatMul_759);

% Add:
Vars.x_Encoders_layer_144 = Vars.Encoders_layers_1__1 + Vars.x_Encoders_layer_145;
NumDims.x_Encoders_layer_144 = max(NumDims.Encoders_layers_1__1, NumDims.x_Encoders_layer_145);

% Add:
Vars.x_Encoders_layers_1_ = Vars.x_Encoders_layer_140 + Vars.x_Encoders_layer_144;
NumDims.x_Encoders_layers_1_ = max(NumDims.x_Encoders_layer_140, NumDims.x_Encoders_layer_144);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1250, NumDims.x_Encoders_layers_1_);
Vars.x_Encoders_layer_293 = mean(Vars.x_Encoders_layers_1_, dims);
NumDims.x_Encoders_layer_293 = NumDims.x_Encoders_layers_1_;

% Sub:
Vars.x_Encoders_layer_295 = Vars.x_Encoders_layers_1_ - Vars.x_Encoders_layer_293;
NumDims.x_Encoders_layer_295 = max(NumDims.x_Encoders_layers_1_, NumDims.x_Encoders_layer_293);

% Pow:
Vars.x_Encoders_layer_291 = power(Vars.x_Encoders_layer_295, Vars.x_Encoders_layer_288);
NumDims.x_Encoders_layer_291 = max(NumDims.x_Encoders_layer_295, NumDims.x_Encoders_layer_288);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1251, NumDims.x_Encoders_layer_291);
Vars.x_Encoders_layer_292 = mean(Vars.x_Encoders_layer_291, dims);
NumDims.x_Encoders_layer_292 = NumDims.x_Encoders_layer_291;

% Add:
Vars.x_Encoders_layer_286 = Vars.x_Encoders_layer_292 + Vars.x_Encoders_layer_287;
NumDims.x_Encoders_layer_286 = max(NumDims.x_Encoders_layer_292, NumDims.x_Encoders_layer_287);

% Sqrt:
Vars.x_Encoders_layer_294 = sqrt(Vars.x_Encoders_layer_286);
NumDims.x_Encoders_layer_294 = NumDims.x_Encoders_layer_286;

% Div:
Vars.x_Encoders_layer_289 = Vars.x_Encoders_layer_295 ./ Vars.x_Encoders_layer_294;
NumDims.x_Encoders_layer_289 = max(NumDims.x_Encoders_layer_295, NumDims.x_Encoders_layer_294);

% Mul:
Vars.x_Encoders_layer_290 = Vars.x_Encoders_layer_289 .* Vars.Encoders_layers_2__2;
NumDims.x_Encoders_layer_290 = max(NumDims.x_Encoders_layer_289, NumDims.Encoders_layers_2__2);

% Add:
Vars.x_Encoders_layer_285 = Vars.x_Encoders_layer_290 + Vars.Encoders_layers_2_no;
NumDims.x_Encoders_layer_285 = max(NumDims.x_Encoders_layer_290, NumDims.Encoders_layers_2_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_347] = prepareTransposeArgs(Vars.TransposePerm1252, NumDims.x_Encoders_layer_285);
if ~isempty(perm)
    Vars.x_Encoders_layer_347 = permute(Vars.x_Encoders_layer_285, perm);
end

% MatMul:
[Vars.x_Encoders_layer_328, NumDims.x_Encoders_layer_328] = onnxMatMul(Vars.x_Encoders_layer_347, Vars.onnx__MatMul_760, NumDims.x_Encoders_layer_347, NumDims.onnx__MatMul_760);

% Add:
Vars.x_Encoders_layer_308 = Vars.Encoders_layers_2_se + Vars.x_Encoders_layer_328;
NumDims.x_Encoders_layer_308 = max(NumDims.Encoders_layers_2_se, NumDims.x_Encoders_layer_328);

% Shape:
[Vars.x_Encoders_layer_337, NumDims.x_Encoders_layer_337] = onnxShape(Vars.x_Encoders_layer_308, NumDims.x_Encoders_layer_308);

% Gather:
[Vars.x_Encoders_layer_324, NumDims.x_Encoders_layer_324] = onnxGather(Vars.x_Encoders_layer_337, Vars.x_Encoders_layer_321, 0, NumDims.x_Encoders_layer_337, NumDims.x_Encoders_layer_321);

% Add:
Vars.x_Encoders_layer_307 = Vars.x_Encoders_layer_324 + Vars.x_Encoders_layer_313;
NumDims.x_Encoders_layer_307 = max(NumDims.x_Encoders_layer_324, NumDims.x_Encoders_layer_313);

% Div:
Vars.x_Encoders_layer_323 = fix(Vars.x_Encoders_layer_307 ./ Vars.x_Encoders_layer_314);
NumDims.x_Encoders_layer_323 = max(NumDims.x_Encoders_layer_307, NumDims.x_Encoders_layer_314);

% Mul:
Vars.x_Encoders_layer_331 = Vars.x_Encoders_layer_323 .* Vars.x_Encoders_layer_315;
NumDims.x_Encoders_layer_331 = max(NumDims.x_Encoders_layer_323, NumDims.x_Encoders_layer_315);

% Slice:
[Indices, NumDims.x_Encoders_layer_340] = prepareSliceArgs(Vars.x_Encoders_layer_308, Vars.x_Encoders_layer_312, Vars.x_Encoders_layer_331, Vars.x_Encoders_layer_321, '', NumDims.x_Encoders_layer_308);
Vars.x_Encoders_layer_340 = subsref(Vars.x_Encoders_layer_308, Indices);

% Mul:
Vars.x_Encoders_layer_329 = Vars.x_Encoders_layer_323 .* Vars.x_Encoders_layer_316;
NumDims.x_Encoders_layer_329 = max(NumDims.x_Encoders_layer_323, NumDims.x_Encoders_layer_316);

% Slice:
[Indices, NumDims.x_Encoders_layer_338] = prepareSliceArgs(Vars.x_Encoders_layer_308, Vars.x_Encoders_layer_331, Vars.x_Encoders_layer_329, Vars.x_Encoders_layer_321, '', NumDims.x_Encoders_layer_308);
Vars.x_Encoders_layer_338 = subsref(Vars.x_Encoders_layer_308, Indices);

% Mul:
Vars.x_Encoders_layer_330 = Vars.x_Encoders_layer_323 .* Vars.x_Encoders_layer_317;
NumDims.x_Encoders_layer_330 = max(NumDims.x_Encoders_layer_323, NumDims.x_Encoders_layer_317);

% Slice:
[Indices, NumDims.x_Encoders_layer_339] = prepareSliceArgs(Vars.x_Encoders_layer_308, Vars.x_Encoders_layer_329, Vars.x_Encoders_layer_330, Vars.x_Encoders_layer_321, '', NumDims.x_Encoders_layer_308);
Vars.x_Encoders_layer_339 = subsref(Vars.x_Encoders_layer_308, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_336] = prepareReshapeArgs(Vars.x_Encoders_layer_340, Vars.x_Encoders_layer_318, NumDims.x_Encoders_layer_340, 0);
Vars.x_Encoders_layer_336 = reshape(Vars.x_Encoders_layer_340, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_342] = prepareTransposeArgs(Vars.TransposePerm1253, NumDims.x_Encoders_layer_336);
if ~isempty(perm)
    Vars.x_Encoders_layer_342 = permute(Vars.x_Encoders_layer_336, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_332] = prepareReshapeArgs(Vars.x_Encoders_layer_338, Vars.x_Encoders_layer_319, NumDims.x_Encoders_layer_338, 0);
Vars.x_Encoders_layer_332 = reshape(Vars.x_Encoders_layer_338, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_333] = prepareReshapeArgs(Vars.x_Encoders_layer_339, Vars.x_Encoders_layer_320, NumDims.x_Encoders_layer_339, 0);
Vars.x_Encoders_layer_333 = reshape(Vars.x_Encoders_layer_339, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_343] = prepareTransposeArgs(Vars.TransposePerm1254, NumDims.x_Encoders_layer_333);
if ~isempty(perm)
    Vars.x_Encoders_layer_343 = permute(Vars.x_Encoders_layer_333, perm);
end

% Div:
Vars.x_Encoders_layer_322 = Vars.x_Encoders_layer_342 ./ Vars.x_Encoders_layer_309;
NumDims.x_Encoders_layer_322 = max(NumDims.x_Encoders_layer_342, NumDims.x_Encoders_layer_309);

% Transpose:
[perm, NumDims.x_Encoders_layer_344] = prepareTransposeArgs(Vars.TransposePerm1255, NumDims.x_Encoders_layer_332);
if ~isempty(perm)
    Vars.x_Encoders_layer_344 = permute(Vars.x_Encoders_layer_332, perm);
end

% MatMul:
[Vars.x_Encoders_layer_326, NumDims.x_Encoders_layer_326] = onnxMatMul(Vars.x_Encoders_layer_322, Vars.x_Encoders_layer_344, NumDims.x_Encoders_layer_322, NumDims.x_Encoders_layer_344);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_341] = prepareSoftmaxArgs(Vars.x_Encoders_layer_326, 2, NumDims.x_Encoders_layer_326);
Vars.x_Encoders_layer_341 = reshape(Vars.x_Encoders_layer_326, dim1, dim2);
Vars.x_Encoders_layer_341 = softmax(Vars.x_Encoders_layer_341, 'DataFormat', 'CB');
Vars.x_Encoders_layer_341 = reshape(Vars.x_Encoders_layer_341, origSize);

% MatMul:
[Vars.x_Encoders_layer_327, NumDims.x_Encoders_layer_327] = onnxMatMul(Vars.x_Encoders_layer_341, Vars.x_Encoders_layer_343, NumDims.x_Encoders_layer_341, NumDims.x_Encoders_layer_343);

% Transpose:
[perm, NumDims.x_Encoders_layer_345] = prepareTransposeArgs(Vars.TransposePerm1256, NumDims.x_Encoders_layer_327);
if ~isempty(perm)
    Vars.x_Encoders_layer_345 = permute(Vars.x_Encoders_layer_327, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_334] = prepareReshapeArgs(Vars.x_Encoders_layer_345, Vars.x_Encoders_layer_310, NumDims.x_Encoders_layer_345, 0);
Vars.x_Encoders_layer_334 = reshape(Vars.x_Encoders_layer_345, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_325] = prepareGemmArgs(Vars.x_Encoders_layer_334, Vars.Encoders_layers_2__6, Vars.Encoders_layers_2__5, Vars.Gemmalpha1257, Vars.Gemmbeta1258, 0, 1, NumDims.Encoders_layers_2__5);
Vars.x_Encoders_layer_325 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_335] = prepareReshapeArgs(Vars.x_Encoders_layer_325, Vars.x_Encoders_layer_311, NumDims.x_Encoders_layer_325, 0);
Vars.x_Encoders_layer_335 = reshape(Vars.x_Encoders_layer_325, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_346] = prepareTransposeArgs(Vars.TransposePerm1259, NumDims.x_Encoders_layer_335);
if ~isempty(perm)
    Vars.x_Encoders_layer_346 = permute(Vars.x_Encoders_layer_335, perm);
end

% Add:
Vars.x_Encoders_layer_279 = Vars.x_Encoders_layers_1_ + Vars.x_Encoders_layer_346;
NumDims.x_Encoders_layer_279 = max(NumDims.x_Encoders_layers_1_, NumDims.x_Encoders_layer_346);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1260, NumDims.x_Encoders_layer_279);
Vars.x_Encoders_layer_304 = mean(Vars.x_Encoders_layer_279, dims);
NumDims.x_Encoders_layer_304 = NumDims.x_Encoders_layer_279;

% Sub:
Vars.x_Encoders_layer_306 = Vars.x_Encoders_layer_279 - Vars.x_Encoders_layer_304;
NumDims.x_Encoders_layer_306 = max(NumDims.x_Encoders_layer_279, NumDims.x_Encoders_layer_304);

% Pow:
Vars.x_Encoders_layer_302 = power(Vars.x_Encoders_layer_306, Vars.x_Encoders_layer_299);
NumDims.x_Encoders_layer_302 = max(NumDims.x_Encoders_layer_306, NumDims.x_Encoders_layer_299);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1261, NumDims.x_Encoders_layer_302);
Vars.x_Encoders_layer_303 = mean(Vars.x_Encoders_layer_302, dims);
NumDims.x_Encoders_layer_303 = NumDims.x_Encoders_layer_302;

% Add:
Vars.x_Encoders_layer_297 = Vars.x_Encoders_layer_303 + Vars.x_Encoders_layer_298;
NumDims.x_Encoders_layer_297 = max(NumDims.x_Encoders_layer_303, NumDims.x_Encoders_layer_298);

% Sqrt:
Vars.x_Encoders_layer_305 = sqrt(Vars.x_Encoders_layer_297);
NumDims.x_Encoders_layer_305 = NumDims.x_Encoders_layer_297;

% Div:
Vars.x_Encoders_layer_300 = Vars.x_Encoders_layer_306 ./ Vars.x_Encoders_layer_305;
NumDims.x_Encoders_layer_300 = max(NumDims.x_Encoders_layer_306, NumDims.x_Encoders_layer_305);

% Mul:
Vars.x_Encoders_layer_301 = Vars.x_Encoders_layer_300 .* Vars.Encoders_layers_2__4;
NumDims.x_Encoders_layer_301 = max(NumDims.x_Encoders_layer_300, NumDims.Encoders_layers_2__4);

% Add:
Vars.x_Encoders_layer_296 = Vars.x_Encoders_layer_301 + Vars.Encoders_layers_2__3;
NumDims.x_Encoders_layer_296 = max(NumDims.x_Encoders_layer_301, NumDims.Encoders_layers_2__3);

% MatMul:
[Vars.x_Encoders_layer_282, NumDims.x_Encoders_layer_282] = onnxMatMul(Vars.x_Encoders_layer_296, Vars.onnx__MatMul_780, NumDims.x_Encoders_layer_296, NumDims.onnx__MatMul_780);

% Add:
Vars.x_Encoders_layer_281 = Vars.Encoders_layers_2_li + Vars.x_Encoders_layer_282;
NumDims.x_Encoders_layer_281 = max(NumDims.Encoders_layers_2_li, NumDims.x_Encoders_layer_282);

% Relu:
Vars.x_Encoders_layer_280 = relu(Vars.x_Encoders_layer_281);
NumDims.x_Encoders_layer_280 = NumDims.x_Encoders_layer_281;

% MatMul:
[Vars.x_Encoders_layer_284, NumDims.x_Encoders_layer_284] = onnxMatMul(Vars.x_Encoders_layer_280, Vars.onnx__MatMul_781, NumDims.x_Encoders_layer_280, NumDims.onnx__MatMul_781);

% Add:
Vars.x_Encoders_layer_283 = Vars.Encoders_layers_2__1 + Vars.x_Encoders_layer_284;
NumDims.x_Encoders_layer_283 = max(NumDims.Encoders_layers_2__1, NumDims.x_Encoders_layer_284);

% Add:
Vars.x_Encoders_layers_2_ = Vars.x_Encoders_layer_279 + Vars.x_Encoders_layer_283;
NumDims.x_Encoders_layers_2_ = max(NumDims.x_Encoders_layer_279, NumDims.x_Encoders_layer_283);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1262, NumDims.x_Encoders_layers_2_);
Vars.x_Encoders_layer_432 = mean(Vars.x_Encoders_layers_2_, dims);
NumDims.x_Encoders_layer_432 = NumDims.x_Encoders_layers_2_;

% Sub:
Vars.x_Encoders_layer_434 = Vars.x_Encoders_layers_2_ - Vars.x_Encoders_layer_432;
NumDims.x_Encoders_layer_434 = max(NumDims.x_Encoders_layers_2_, NumDims.x_Encoders_layer_432);

% Pow:
Vars.x_Encoders_layer_430 = power(Vars.x_Encoders_layer_434, Vars.x_Encoders_layer_427);
NumDims.x_Encoders_layer_430 = max(NumDims.x_Encoders_layer_434, NumDims.x_Encoders_layer_427);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1263, NumDims.x_Encoders_layer_430);
Vars.x_Encoders_layer_431 = mean(Vars.x_Encoders_layer_430, dims);
NumDims.x_Encoders_layer_431 = NumDims.x_Encoders_layer_430;

% Add:
Vars.x_Encoders_layer_425 = Vars.x_Encoders_layer_431 + Vars.x_Encoders_layer_426;
NumDims.x_Encoders_layer_425 = max(NumDims.x_Encoders_layer_431, NumDims.x_Encoders_layer_426);

% Sqrt:
Vars.x_Encoders_layer_433 = sqrt(Vars.x_Encoders_layer_425);
NumDims.x_Encoders_layer_433 = NumDims.x_Encoders_layer_425;

% Div:
Vars.x_Encoders_layer_428 = Vars.x_Encoders_layer_434 ./ Vars.x_Encoders_layer_433;
NumDims.x_Encoders_layer_428 = max(NumDims.x_Encoders_layer_434, NumDims.x_Encoders_layer_433);

% Mul:
Vars.x_Encoders_layer_429 = Vars.x_Encoders_layer_428 .* Vars.Encoders_layers_3__2;
NumDims.x_Encoders_layer_429 = max(NumDims.x_Encoders_layer_428, NumDims.Encoders_layers_3__2);

% Add:
Vars.x_Encoders_layer_424 = Vars.x_Encoders_layer_429 + Vars.Encoders_layers_3_no;
NumDims.x_Encoders_layer_424 = max(NumDims.x_Encoders_layer_429, NumDims.Encoders_layers_3_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_486] = prepareTransposeArgs(Vars.TransposePerm1264, NumDims.x_Encoders_layer_424);
if ~isempty(perm)
    Vars.x_Encoders_layer_486 = permute(Vars.x_Encoders_layer_424, perm);
end

% MatMul:
[Vars.x_Encoders_layer_467, NumDims.x_Encoders_layer_467] = onnxMatMul(Vars.x_Encoders_layer_486, Vars.onnx__MatMul_782, NumDims.x_Encoders_layer_486, NumDims.onnx__MatMul_782);

% Add:
Vars.x_Encoders_layer_447 = Vars.Encoders_layers_3_se + Vars.x_Encoders_layer_467;
NumDims.x_Encoders_layer_447 = max(NumDims.Encoders_layers_3_se, NumDims.x_Encoders_layer_467);

% Shape:
[Vars.x_Encoders_layer_476, NumDims.x_Encoders_layer_476] = onnxShape(Vars.x_Encoders_layer_447, NumDims.x_Encoders_layer_447);

% Gather:
[Vars.x_Encoders_layer_463, NumDims.x_Encoders_layer_463] = onnxGather(Vars.x_Encoders_layer_476, Vars.x_Encoders_layer_460, 0, NumDims.x_Encoders_layer_476, NumDims.x_Encoders_layer_460);

% Add:
Vars.x_Encoders_layer_446 = Vars.x_Encoders_layer_463 + Vars.x_Encoders_layer_452;
NumDims.x_Encoders_layer_446 = max(NumDims.x_Encoders_layer_463, NumDims.x_Encoders_layer_452);

% Div:
Vars.x_Encoders_layer_462 = fix(Vars.x_Encoders_layer_446 ./ Vars.x_Encoders_layer_453);
NumDims.x_Encoders_layer_462 = max(NumDims.x_Encoders_layer_446, NumDims.x_Encoders_layer_453);

% Mul:
Vars.x_Encoders_layer_470 = Vars.x_Encoders_layer_462 .* Vars.x_Encoders_layer_454;
NumDims.x_Encoders_layer_470 = max(NumDims.x_Encoders_layer_462, NumDims.x_Encoders_layer_454);

% Slice:
[Indices, NumDims.x_Encoders_layer_479] = prepareSliceArgs(Vars.x_Encoders_layer_447, Vars.x_Encoders_layer_451, Vars.x_Encoders_layer_470, Vars.x_Encoders_layer_460, '', NumDims.x_Encoders_layer_447);
Vars.x_Encoders_layer_479 = subsref(Vars.x_Encoders_layer_447, Indices);

% Mul:
Vars.x_Encoders_layer_468 = Vars.x_Encoders_layer_462 .* Vars.x_Encoders_layer_455;
NumDims.x_Encoders_layer_468 = max(NumDims.x_Encoders_layer_462, NumDims.x_Encoders_layer_455);

% Slice:
[Indices, NumDims.x_Encoders_layer_477] = prepareSliceArgs(Vars.x_Encoders_layer_447, Vars.x_Encoders_layer_470, Vars.x_Encoders_layer_468, Vars.x_Encoders_layer_460, '', NumDims.x_Encoders_layer_447);
Vars.x_Encoders_layer_477 = subsref(Vars.x_Encoders_layer_447, Indices);

% Mul:
Vars.x_Encoders_layer_469 = Vars.x_Encoders_layer_462 .* Vars.x_Encoders_layer_456;
NumDims.x_Encoders_layer_469 = max(NumDims.x_Encoders_layer_462, NumDims.x_Encoders_layer_456);

% Slice:
[Indices, NumDims.x_Encoders_layer_478] = prepareSliceArgs(Vars.x_Encoders_layer_447, Vars.x_Encoders_layer_468, Vars.x_Encoders_layer_469, Vars.x_Encoders_layer_460, '', NumDims.x_Encoders_layer_447);
Vars.x_Encoders_layer_478 = subsref(Vars.x_Encoders_layer_447, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_475] = prepareReshapeArgs(Vars.x_Encoders_layer_479, Vars.x_Encoders_layer_457, NumDims.x_Encoders_layer_479, 0);
Vars.x_Encoders_layer_475 = reshape(Vars.x_Encoders_layer_479, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_481] = prepareTransposeArgs(Vars.TransposePerm1265, NumDims.x_Encoders_layer_475);
if ~isempty(perm)
    Vars.x_Encoders_layer_481 = permute(Vars.x_Encoders_layer_475, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_471] = prepareReshapeArgs(Vars.x_Encoders_layer_477, Vars.x_Encoders_layer_458, NumDims.x_Encoders_layer_477, 0);
Vars.x_Encoders_layer_471 = reshape(Vars.x_Encoders_layer_477, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_472] = prepareReshapeArgs(Vars.x_Encoders_layer_478, Vars.x_Encoders_layer_459, NumDims.x_Encoders_layer_478, 0);
Vars.x_Encoders_layer_472 = reshape(Vars.x_Encoders_layer_478, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_482] = prepareTransposeArgs(Vars.TransposePerm1266, NumDims.x_Encoders_layer_472);
if ~isempty(perm)
    Vars.x_Encoders_layer_482 = permute(Vars.x_Encoders_layer_472, perm);
end

% Div:
Vars.x_Encoders_layer_461 = Vars.x_Encoders_layer_481 ./ Vars.x_Encoders_layer_448;
NumDims.x_Encoders_layer_461 = max(NumDims.x_Encoders_layer_481, NumDims.x_Encoders_layer_448);

% Transpose:
[perm, NumDims.x_Encoders_layer_483] = prepareTransposeArgs(Vars.TransposePerm1267, NumDims.x_Encoders_layer_471);
if ~isempty(perm)
    Vars.x_Encoders_layer_483 = permute(Vars.x_Encoders_layer_471, perm);
end

% MatMul:
[Vars.x_Encoders_layer_465, NumDims.x_Encoders_layer_465] = onnxMatMul(Vars.x_Encoders_layer_461, Vars.x_Encoders_layer_483, NumDims.x_Encoders_layer_461, NumDims.x_Encoders_layer_483);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_480] = prepareSoftmaxArgs(Vars.x_Encoders_layer_465, 2, NumDims.x_Encoders_layer_465);
Vars.x_Encoders_layer_480 = reshape(Vars.x_Encoders_layer_465, dim1, dim2);
Vars.x_Encoders_layer_480 = softmax(Vars.x_Encoders_layer_480, 'DataFormat', 'CB');
Vars.x_Encoders_layer_480 = reshape(Vars.x_Encoders_layer_480, origSize);

% MatMul:
[Vars.x_Encoders_layer_466, NumDims.x_Encoders_layer_466] = onnxMatMul(Vars.x_Encoders_layer_480, Vars.x_Encoders_layer_482, NumDims.x_Encoders_layer_480, NumDims.x_Encoders_layer_482);

% Transpose:
[perm, NumDims.x_Encoders_layer_484] = prepareTransposeArgs(Vars.TransposePerm1268, NumDims.x_Encoders_layer_466);
if ~isempty(perm)
    Vars.x_Encoders_layer_484 = permute(Vars.x_Encoders_layer_466, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_473] = prepareReshapeArgs(Vars.x_Encoders_layer_484, Vars.x_Encoders_layer_449, NumDims.x_Encoders_layer_484, 0);
Vars.x_Encoders_layer_473 = reshape(Vars.x_Encoders_layer_484, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_464] = prepareGemmArgs(Vars.x_Encoders_layer_473, Vars.Encoders_layers_3__6, Vars.Encoders_layers_3__5, Vars.Gemmalpha1269, Vars.Gemmbeta1270, 0, 1, NumDims.Encoders_layers_3__5);
Vars.x_Encoders_layer_464 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_474] = prepareReshapeArgs(Vars.x_Encoders_layer_464, Vars.x_Encoders_layer_450, NumDims.x_Encoders_layer_464, 0);
Vars.x_Encoders_layer_474 = reshape(Vars.x_Encoders_layer_464, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_485] = prepareTransposeArgs(Vars.TransposePerm1271, NumDims.x_Encoders_layer_474);
if ~isempty(perm)
    Vars.x_Encoders_layer_485 = permute(Vars.x_Encoders_layer_474, perm);
end

% Add:
Vars.x_Encoders_layer_418 = Vars.x_Encoders_layers_2_ + Vars.x_Encoders_layer_485;
NumDims.x_Encoders_layer_418 = max(NumDims.x_Encoders_layers_2_, NumDims.x_Encoders_layer_485);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1272, NumDims.x_Encoders_layer_418);
Vars.x_Encoders_layer_443 = mean(Vars.x_Encoders_layer_418, dims);
NumDims.x_Encoders_layer_443 = NumDims.x_Encoders_layer_418;

% Sub:
Vars.x_Encoders_layer_445 = Vars.x_Encoders_layer_418 - Vars.x_Encoders_layer_443;
NumDims.x_Encoders_layer_445 = max(NumDims.x_Encoders_layer_418, NumDims.x_Encoders_layer_443);

% Pow:
Vars.x_Encoders_layer_441 = power(Vars.x_Encoders_layer_445, Vars.x_Encoders_layer_438);
NumDims.x_Encoders_layer_441 = max(NumDims.x_Encoders_layer_445, NumDims.x_Encoders_layer_438);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1273, NumDims.x_Encoders_layer_441);
Vars.x_Encoders_layer_442 = mean(Vars.x_Encoders_layer_441, dims);
NumDims.x_Encoders_layer_442 = NumDims.x_Encoders_layer_441;

% Add:
Vars.x_Encoders_layer_436 = Vars.x_Encoders_layer_442 + Vars.x_Encoders_layer_437;
NumDims.x_Encoders_layer_436 = max(NumDims.x_Encoders_layer_442, NumDims.x_Encoders_layer_437);

% Sqrt:
Vars.x_Encoders_layer_444 = sqrt(Vars.x_Encoders_layer_436);
NumDims.x_Encoders_layer_444 = NumDims.x_Encoders_layer_436;

% Div:
Vars.x_Encoders_layer_439 = Vars.x_Encoders_layer_445 ./ Vars.x_Encoders_layer_444;
NumDims.x_Encoders_layer_439 = max(NumDims.x_Encoders_layer_445, NumDims.x_Encoders_layer_444);

% Mul:
Vars.x_Encoders_layer_440 = Vars.x_Encoders_layer_439 .* Vars.Encoders_layers_3__4;
NumDims.x_Encoders_layer_440 = max(NumDims.x_Encoders_layer_439, NumDims.Encoders_layers_3__4);

% Add:
Vars.x_Encoders_layer_435 = Vars.x_Encoders_layer_440 + Vars.Encoders_layers_3__3;
NumDims.x_Encoders_layer_435 = max(NumDims.x_Encoders_layer_440, NumDims.Encoders_layers_3__3);

% MatMul:
[Vars.x_Encoders_layer_421, NumDims.x_Encoders_layer_421] = onnxMatMul(Vars.x_Encoders_layer_435, Vars.onnx__MatMul_802, NumDims.x_Encoders_layer_435, NumDims.onnx__MatMul_802);

% Add:
Vars.x_Encoders_layer_420 = Vars.Encoders_layers_3_li + Vars.x_Encoders_layer_421;
NumDims.x_Encoders_layer_420 = max(NumDims.Encoders_layers_3_li, NumDims.x_Encoders_layer_421);

% Relu:
Vars.x_Encoders_layer_419 = relu(Vars.x_Encoders_layer_420);
NumDims.x_Encoders_layer_419 = NumDims.x_Encoders_layer_420;

% MatMul:
[Vars.x_Encoders_layer_423, NumDims.x_Encoders_layer_423] = onnxMatMul(Vars.x_Encoders_layer_419, Vars.onnx__MatMul_803, NumDims.x_Encoders_layer_419, NumDims.onnx__MatMul_803);

% Add:
Vars.x_Encoders_layer_422 = Vars.Encoders_layers_3__1 + Vars.x_Encoders_layer_423;
NumDims.x_Encoders_layer_422 = max(NumDims.Encoders_layers_3__1, NumDims.x_Encoders_layer_423);

% Add:
Vars.x_Encoders_layers_3_ = Vars.x_Encoders_layer_418 + Vars.x_Encoders_layer_422;
NumDims.x_Encoders_layers_3_ = max(NumDims.x_Encoders_layer_418, NumDims.x_Encoders_layer_422);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1274, NumDims.x_Encoders_layers_3_);
Vars.x_Encoders_layer_571 = mean(Vars.x_Encoders_layers_3_, dims);
NumDims.x_Encoders_layer_571 = NumDims.x_Encoders_layers_3_;

% Sub:
Vars.x_Encoders_layer_573 = Vars.x_Encoders_layers_3_ - Vars.x_Encoders_layer_571;
NumDims.x_Encoders_layer_573 = max(NumDims.x_Encoders_layers_3_, NumDims.x_Encoders_layer_571);

% Pow:
Vars.x_Encoders_layer_569 = power(Vars.x_Encoders_layer_573, Vars.x_Encoders_layer_566);
NumDims.x_Encoders_layer_569 = max(NumDims.x_Encoders_layer_573, NumDims.x_Encoders_layer_566);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1275, NumDims.x_Encoders_layer_569);
Vars.x_Encoders_layer_570 = mean(Vars.x_Encoders_layer_569, dims);
NumDims.x_Encoders_layer_570 = NumDims.x_Encoders_layer_569;

% Add:
Vars.x_Encoders_layer_564 = Vars.x_Encoders_layer_570 + Vars.x_Encoders_layer_565;
NumDims.x_Encoders_layer_564 = max(NumDims.x_Encoders_layer_570, NumDims.x_Encoders_layer_565);

% Sqrt:
Vars.x_Encoders_layer_572 = sqrt(Vars.x_Encoders_layer_564);
NumDims.x_Encoders_layer_572 = NumDims.x_Encoders_layer_564;

% Div:
Vars.x_Encoders_layer_567 = Vars.x_Encoders_layer_573 ./ Vars.x_Encoders_layer_572;
NumDims.x_Encoders_layer_567 = max(NumDims.x_Encoders_layer_573, NumDims.x_Encoders_layer_572);

% Mul:
Vars.x_Encoders_layer_568 = Vars.x_Encoders_layer_567 .* Vars.Encoders_layers_4__2;
NumDims.x_Encoders_layer_568 = max(NumDims.x_Encoders_layer_567, NumDims.Encoders_layers_4__2);

% Add:
Vars.x_Encoders_layer_563 = Vars.x_Encoders_layer_568 + Vars.Encoders_layers_4_no;
NumDims.x_Encoders_layer_563 = max(NumDims.x_Encoders_layer_568, NumDims.Encoders_layers_4_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_625] = prepareTransposeArgs(Vars.TransposePerm1276, NumDims.x_Encoders_layer_563);
if ~isempty(perm)
    Vars.x_Encoders_layer_625 = permute(Vars.x_Encoders_layer_563, perm);
end

% MatMul:
[Vars.x_Encoders_layer_606, NumDims.x_Encoders_layer_606] = onnxMatMul(Vars.x_Encoders_layer_625, Vars.onnx__MatMul_804, NumDims.x_Encoders_layer_625, NumDims.onnx__MatMul_804);

% Add:
Vars.x_Encoders_layer_586 = Vars.Encoders_layers_4_se + Vars.x_Encoders_layer_606;
NumDims.x_Encoders_layer_586 = max(NumDims.Encoders_layers_4_se, NumDims.x_Encoders_layer_606);

% Shape:
[Vars.x_Encoders_layer_615, NumDims.x_Encoders_layer_615] = onnxShape(Vars.x_Encoders_layer_586, NumDims.x_Encoders_layer_586);

% Gather:
[Vars.x_Encoders_layer_602, NumDims.x_Encoders_layer_602] = onnxGather(Vars.x_Encoders_layer_615, Vars.x_Encoders_layer_599, 0, NumDims.x_Encoders_layer_615, NumDims.x_Encoders_layer_599);

% Add:
Vars.x_Encoders_layer_585 = Vars.x_Encoders_layer_602 + Vars.x_Encoders_layer_591;
NumDims.x_Encoders_layer_585 = max(NumDims.x_Encoders_layer_602, NumDims.x_Encoders_layer_591);

% Div:
Vars.x_Encoders_layer_601 = fix(Vars.x_Encoders_layer_585 ./ Vars.x_Encoders_layer_592);
NumDims.x_Encoders_layer_601 = max(NumDims.x_Encoders_layer_585, NumDims.x_Encoders_layer_592);

% Mul:
Vars.x_Encoders_layer_609 = Vars.x_Encoders_layer_601 .* Vars.x_Encoders_layer_593;
NumDims.x_Encoders_layer_609 = max(NumDims.x_Encoders_layer_601, NumDims.x_Encoders_layer_593);

% Slice:
[Indices, NumDims.x_Encoders_layer_618] = prepareSliceArgs(Vars.x_Encoders_layer_586, Vars.x_Encoders_layer_590, Vars.x_Encoders_layer_609, Vars.x_Encoders_layer_599, '', NumDims.x_Encoders_layer_586);
Vars.x_Encoders_layer_618 = subsref(Vars.x_Encoders_layer_586, Indices);

% Mul:
Vars.x_Encoders_layer_607 = Vars.x_Encoders_layer_601 .* Vars.x_Encoders_layer_594;
NumDims.x_Encoders_layer_607 = max(NumDims.x_Encoders_layer_601, NumDims.x_Encoders_layer_594);

% Slice:
[Indices, NumDims.x_Encoders_layer_616] = prepareSliceArgs(Vars.x_Encoders_layer_586, Vars.x_Encoders_layer_609, Vars.x_Encoders_layer_607, Vars.x_Encoders_layer_599, '', NumDims.x_Encoders_layer_586);
Vars.x_Encoders_layer_616 = subsref(Vars.x_Encoders_layer_586, Indices);

% Mul:
Vars.x_Encoders_layer_608 = Vars.x_Encoders_layer_601 .* Vars.x_Encoders_layer_595;
NumDims.x_Encoders_layer_608 = max(NumDims.x_Encoders_layer_601, NumDims.x_Encoders_layer_595);

% Slice:
[Indices, NumDims.x_Encoders_layer_617] = prepareSliceArgs(Vars.x_Encoders_layer_586, Vars.x_Encoders_layer_607, Vars.x_Encoders_layer_608, Vars.x_Encoders_layer_599, '', NumDims.x_Encoders_layer_586);
Vars.x_Encoders_layer_617 = subsref(Vars.x_Encoders_layer_586, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_614] = prepareReshapeArgs(Vars.x_Encoders_layer_618, Vars.x_Encoders_layer_596, NumDims.x_Encoders_layer_618, 0);
Vars.x_Encoders_layer_614 = reshape(Vars.x_Encoders_layer_618, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_620] = prepareTransposeArgs(Vars.TransposePerm1277, NumDims.x_Encoders_layer_614);
if ~isempty(perm)
    Vars.x_Encoders_layer_620 = permute(Vars.x_Encoders_layer_614, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_610] = prepareReshapeArgs(Vars.x_Encoders_layer_616, Vars.x_Encoders_layer_597, NumDims.x_Encoders_layer_616, 0);
Vars.x_Encoders_layer_610 = reshape(Vars.x_Encoders_layer_616, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_611] = prepareReshapeArgs(Vars.x_Encoders_layer_617, Vars.x_Encoders_layer_598, NumDims.x_Encoders_layer_617, 0);
Vars.x_Encoders_layer_611 = reshape(Vars.x_Encoders_layer_617, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_621] = prepareTransposeArgs(Vars.TransposePerm1278, NumDims.x_Encoders_layer_611);
if ~isempty(perm)
    Vars.x_Encoders_layer_621 = permute(Vars.x_Encoders_layer_611, perm);
end

% Div:
Vars.x_Encoders_layer_600 = Vars.x_Encoders_layer_620 ./ Vars.x_Encoders_layer_587;
NumDims.x_Encoders_layer_600 = max(NumDims.x_Encoders_layer_620, NumDims.x_Encoders_layer_587);

% Transpose:
[perm, NumDims.x_Encoders_layer_622] = prepareTransposeArgs(Vars.TransposePerm1279, NumDims.x_Encoders_layer_610);
if ~isempty(perm)
    Vars.x_Encoders_layer_622 = permute(Vars.x_Encoders_layer_610, perm);
end

% MatMul:
[Vars.x_Encoders_layer_604, NumDims.x_Encoders_layer_604] = onnxMatMul(Vars.x_Encoders_layer_600, Vars.x_Encoders_layer_622, NumDims.x_Encoders_layer_600, NumDims.x_Encoders_layer_622);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_619] = prepareSoftmaxArgs(Vars.x_Encoders_layer_604, 2, NumDims.x_Encoders_layer_604);
Vars.x_Encoders_layer_619 = reshape(Vars.x_Encoders_layer_604, dim1, dim2);
Vars.x_Encoders_layer_619 = softmax(Vars.x_Encoders_layer_619, 'DataFormat', 'CB');
Vars.x_Encoders_layer_619 = reshape(Vars.x_Encoders_layer_619, origSize);

% MatMul:
[Vars.x_Encoders_layer_605, NumDims.x_Encoders_layer_605] = onnxMatMul(Vars.x_Encoders_layer_619, Vars.x_Encoders_layer_621, NumDims.x_Encoders_layer_619, NumDims.x_Encoders_layer_621);

% Transpose:
[perm, NumDims.x_Encoders_layer_623] = prepareTransposeArgs(Vars.TransposePerm1280, NumDims.x_Encoders_layer_605);
if ~isempty(perm)
    Vars.x_Encoders_layer_623 = permute(Vars.x_Encoders_layer_605, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_612] = prepareReshapeArgs(Vars.x_Encoders_layer_623, Vars.x_Encoders_layer_588, NumDims.x_Encoders_layer_623, 0);
Vars.x_Encoders_layer_612 = reshape(Vars.x_Encoders_layer_623, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_603] = prepareGemmArgs(Vars.x_Encoders_layer_612, Vars.Encoders_layers_4__6, Vars.Encoders_layers_4__5, Vars.Gemmalpha1281, Vars.Gemmbeta1282, 0, 1, NumDims.Encoders_layers_4__5);
Vars.x_Encoders_layer_603 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_613] = prepareReshapeArgs(Vars.x_Encoders_layer_603, Vars.x_Encoders_layer_589, NumDims.x_Encoders_layer_603, 0);
Vars.x_Encoders_layer_613 = reshape(Vars.x_Encoders_layer_603, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_624] = prepareTransposeArgs(Vars.TransposePerm1283, NumDims.x_Encoders_layer_613);
if ~isempty(perm)
    Vars.x_Encoders_layer_624 = permute(Vars.x_Encoders_layer_613, perm);
end

% Add:
Vars.x_Encoders_layer_557 = Vars.x_Encoders_layers_3_ + Vars.x_Encoders_layer_624;
NumDims.x_Encoders_layer_557 = max(NumDims.x_Encoders_layers_3_, NumDims.x_Encoders_layer_624);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1284, NumDims.x_Encoders_layer_557);
Vars.x_Encoders_layer_582 = mean(Vars.x_Encoders_layer_557, dims);
NumDims.x_Encoders_layer_582 = NumDims.x_Encoders_layer_557;

% Sub:
Vars.x_Encoders_layer_584 = Vars.x_Encoders_layer_557 - Vars.x_Encoders_layer_582;
NumDims.x_Encoders_layer_584 = max(NumDims.x_Encoders_layer_557, NumDims.x_Encoders_layer_582);

% Pow:
Vars.x_Encoders_layer_580 = power(Vars.x_Encoders_layer_584, Vars.x_Encoders_layer_577);
NumDims.x_Encoders_layer_580 = max(NumDims.x_Encoders_layer_584, NumDims.x_Encoders_layer_577);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1285, NumDims.x_Encoders_layer_580);
Vars.x_Encoders_layer_581 = mean(Vars.x_Encoders_layer_580, dims);
NumDims.x_Encoders_layer_581 = NumDims.x_Encoders_layer_580;

% Add:
Vars.x_Encoders_layer_575 = Vars.x_Encoders_layer_581 + Vars.x_Encoders_layer_576;
NumDims.x_Encoders_layer_575 = max(NumDims.x_Encoders_layer_581, NumDims.x_Encoders_layer_576);

% Sqrt:
Vars.x_Encoders_layer_583 = sqrt(Vars.x_Encoders_layer_575);
NumDims.x_Encoders_layer_583 = NumDims.x_Encoders_layer_575;

% Div:
Vars.x_Encoders_layer_578 = Vars.x_Encoders_layer_584 ./ Vars.x_Encoders_layer_583;
NumDims.x_Encoders_layer_578 = max(NumDims.x_Encoders_layer_584, NumDims.x_Encoders_layer_583);

% Mul:
Vars.x_Encoders_layer_579 = Vars.x_Encoders_layer_578 .* Vars.Encoders_layers_4__4;
NumDims.x_Encoders_layer_579 = max(NumDims.x_Encoders_layer_578, NumDims.Encoders_layers_4__4);

% Add:
Vars.x_Encoders_layer_574 = Vars.x_Encoders_layer_579 + Vars.Encoders_layers_4__3;
NumDims.x_Encoders_layer_574 = max(NumDims.x_Encoders_layer_579, NumDims.Encoders_layers_4__3);

% MatMul:
[Vars.x_Encoders_layer_560, NumDims.x_Encoders_layer_560] = onnxMatMul(Vars.x_Encoders_layer_574, Vars.onnx__MatMul_824, NumDims.x_Encoders_layer_574, NumDims.onnx__MatMul_824);

% Add:
Vars.x_Encoders_layer_559 = Vars.Encoders_layers_4_li + Vars.x_Encoders_layer_560;
NumDims.x_Encoders_layer_559 = max(NumDims.Encoders_layers_4_li, NumDims.x_Encoders_layer_560);

% Relu:
Vars.x_Encoders_layer_558 = relu(Vars.x_Encoders_layer_559);
NumDims.x_Encoders_layer_558 = NumDims.x_Encoders_layer_559;

% MatMul:
[Vars.x_Encoders_layer_562, NumDims.x_Encoders_layer_562] = onnxMatMul(Vars.x_Encoders_layer_558, Vars.onnx__MatMul_825, NumDims.x_Encoders_layer_558, NumDims.onnx__MatMul_825);

% Add:
Vars.x_Encoders_layer_561 = Vars.Encoders_layers_4__1 + Vars.x_Encoders_layer_562;
NumDims.x_Encoders_layer_561 = max(NumDims.Encoders_layers_4__1, NumDims.x_Encoders_layer_562);

% Add:
Vars.x_Encoders_layers_4_ = Vars.x_Encoders_layer_557 + Vars.x_Encoders_layer_561;
NumDims.x_Encoders_layers_4_ = max(NumDims.x_Encoders_layer_557, NumDims.x_Encoders_layer_561);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1286, NumDims.x_Encoders_layers_4_);
Vars.x_Encoders_layer_710 = mean(Vars.x_Encoders_layers_4_, dims);
NumDims.x_Encoders_layer_710 = NumDims.x_Encoders_layers_4_;

% Sub:
Vars.x_Encoders_layer_712 = Vars.x_Encoders_layers_4_ - Vars.x_Encoders_layer_710;
NumDims.x_Encoders_layer_712 = max(NumDims.x_Encoders_layers_4_, NumDims.x_Encoders_layer_710);

% Pow:
Vars.x_Encoders_layer_708 = power(Vars.x_Encoders_layer_712, Vars.x_Encoders_layer_705);
NumDims.x_Encoders_layer_708 = max(NumDims.x_Encoders_layer_712, NumDims.x_Encoders_layer_705);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1287, NumDims.x_Encoders_layer_708);
Vars.x_Encoders_layer_709 = mean(Vars.x_Encoders_layer_708, dims);
NumDims.x_Encoders_layer_709 = NumDims.x_Encoders_layer_708;

% Add:
Vars.x_Encoders_layer_703 = Vars.x_Encoders_layer_709 + Vars.x_Encoders_layer_704;
NumDims.x_Encoders_layer_703 = max(NumDims.x_Encoders_layer_709, NumDims.x_Encoders_layer_704);

% Sqrt:
Vars.x_Encoders_layer_711 = sqrt(Vars.x_Encoders_layer_703);
NumDims.x_Encoders_layer_711 = NumDims.x_Encoders_layer_703;

% Div:
Vars.x_Encoders_layer_706 = Vars.x_Encoders_layer_712 ./ Vars.x_Encoders_layer_711;
NumDims.x_Encoders_layer_706 = max(NumDims.x_Encoders_layer_712, NumDims.x_Encoders_layer_711);

% Mul:
Vars.x_Encoders_layer_707 = Vars.x_Encoders_layer_706 .* Vars.Encoders_layers_5__2;
NumDims.x_Encoders_layer_707 = max(NumDims.x_Encoders_layer_706, NumDims.Encoders_layers_5__2);

% Add:
Vars.x_Encoders_layer_702 = Vars.x_Encoders_layer_707 + Vars.Encoders_layers_5_no;
NumDims.x_Encoders_layer_702 = max(NumDims.x_Encoders_layer_707, NumDims.Encoders_layers_5_no);

% Transpose:
[perm, NumDims.x_Encoders_layer_764] = prepareTransposeArgs(Vars.TransposePerm1288, NumDims.x_Encoders_layer_702);
if ~isempty(perm)
    Vars.x_Encoders_layer_764 = permute(Vars.x_Encoders_layer_702, perm);
end

% MatMul:
[Vars.x_Encoders_layer_745, NumDims.x_Encoders_layer_745] = onnxMatMul(Vars.x_Encoders_layer_764, Vars.onnx__MatMul_826, NumDims.x_Encoders_layer_764, NumDims.onnx__MatMul_826);

% Add:
Vars.x_Encoders_layer_725 = Vars.Encoders_layers_5_se + Vars.x_Encoders_layer_745;
NumDims.x_Encoders_layer_725 = max(NumDims.Encoders_layers_5_se, NumDims.x_Encoders_layer_745);

% Shape:
[Vars.x_Encoders_layer_754, NumDims.x_Encoders_layer_754] = onnxShape(Vars.x_Encoders_layer_725, NumDims.x_Encoders_layer_725);

% Gather:
[Vars.x_Encoders_layer_741, NumDims.x_Encoders_layer_741] = onnxGather(Vars.x_Encoders_layer_754, Vars.x_Encoders_layer_738, 0, NumDims.x_Encoders_layer_754, NumDims.x_Encoders_layer_738);

% Add:
Vars.x_Encoders_layer_724 = Vars.x_Encoders_layer_741 + Vars.x_Encoders_layer_730;
NumDims.x_Encoders_layer_724 = max(NumDims.x_Encoders_layer_741, NumDims.x_Encoders_layer_730);

% Div:
Vars.x_Encoders_layer_740 = fix(Vars.x_Encoders_layer_724 ./ Vars.x_Encoders_layer_731);
NumDims.x_Encoders_layer_740 = max(NumDims.x_Encoders_layer_724, NumDims.x_Encoders_layer_731);

% Mul:
Vars.x_Encoders_layer_748 = Vars.x_Encoders_layer_740 .* Vars.x_Encoders_layer_732;
NumDims.x_Encoders_layer_748 = max(NumDims.x_Encoders_layer_740, NumDims.x_Encoders_layer_732);

% Slice:
[Indices, NumDims.x_Encoders_layer_757] = prepareSliceArgs(Vars.x_Encoders_layer_725, Vars.x_Encoders_layer_729, Vars.x_Encoders_layer_748, Vars.x_Encoders_layer_738, '', NumDims.x_Encoders_layer_725);
Vars.x_Encoders_layer_757 = subsref(Vars.x_Encoders_layer_725, Indices);

% Mul:
Vars.x_Encoders_layer_746 = Vars.x_Encoders_layer_740 .* Vars.x_Encoders_layer_733;
NumDims.x_Encoders_layer_746 = max(NumDims.x_Encoders_layer_740, NumDims.x_Encoders_layer_733);

% Slice:
[Indices, NumDims.x_Encoders_layer_755] = prepareSliceArgs(Vars.x_Encoders_layer_725, Vars.x_Encoders_layer_748, Vars.x_Encoders_layer_746, Vars.x_Encoders_layer_738, '', NumDims.x_Encoders_layer_725);
Vars.x_Encoders_layer_755 = subsref(Vars.x_Encoders_layer_725, Indices);

% Mul:
Vars.x_Encoders_layer_747 = Vars.x_Encoders_layer_740 .* Vars.x_Encoders_layer_734;
NumDims.x_Encoders_layer_747 = max(NumDims.x_Encoders_layer_740, NumDims.x_Encoders_layer_734);

% Slice:
[Indices, NumDims.x_Encoders_layer_756] = prepareSliceArgs(Vars.x_Encoders_layer_725, Vars.x_Encoders_layer_746, Vars.x_Encoders_layer_747, Vars.x_Encoders_layer_738, '', NumDims.x_Encoders_layer_725);
Vars.x_Encoders_layer_756 = subsref(Vars.x_Encoders_layer_725, Indices);

% Reshape:
[shape, NumDims.x_Encoders_layer_753] = prepareReshapeArgs(Vars.x_Encoders_layer_757, Vars.x_Encoders_layer_735, NumDims.x_Encoders_layer_757, 0);
Vars.x_Encoders_layer_753 = reshape(Vars.x_Encoders_layer_757, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_759] = prepareTransposeArgs(Vars.TransposePerm1289, NumDims.x_Encoders_layer_753);
if ~isempty(perm)
    Vars.x_Encoders_layer_759 = permute(Vars.x_Encoders_layer_753, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_749] = prepareReshapeArgs(Vars.x_Encoders_layer_755, Vars.x_Encoders_layer_736, NumDims.x_Encoders_layer_755, 0);
Vars.x_Encoders_layer_749 = reshape(Vars.x_Encoders_layer_755, shape{:});

% Reshape:
[shape, NumDims.x_Encoders_layer_750] = prepareReshapeArgs(Vars.x_Encoders_layer_756, Vars.x_Encoders_layer_737, NumDims.x_Encoders_layer_756, 0);
Vars.x_Encoders_layer_750 = reshape(Vars.x_Encoders_layer_756, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_760] = prepareTransposeArgs(Vars.TransposePerm1290, NumDims.x_Encoders_layer_750);
if ~isempty(perm)
    Vars.x_Encoders_layer_760 = permute(Vars.x_Encoders_layer_750, perm);
end

% Div:
Vars.x_Encoders_layer_739 = Vars.x_Encoders_layer_759 ./ Vars.x_Encoders_layer_726;
NumDims.x_Encoders_layer_739 = max(NumDims.x_Encoders_layer_759, NumDims.x_Encoders_layer_726);

% Transpose:
[perm, NumDims.x_Encoders_layer_761] = prepareTransposeArgs(Vars.TransposePerm1291, NumDims.x_Encoders_layer_749);
if ~isempty(perm)
    Vars.x_Encoders_layer_761 = permute(Vars.x_Encoders_layer_749, perm);
end

% MatMul:
[Vars.x_Encoders_layer_743, NumDims.x_Encoders_layer_743] = onnxMatMul(Vars.x_Encoders_layer_739, Vars.x_Encoders_layer_761, NumDims.x_Encoders_layer_739, NumDims.x_Encoders_layer_761);

% Softmax:
[dim1, dim2, origSize, NumDims.x_Encoders_layer_758] = prepareSoftmaxArgs(Vars.x_Encoders_layer_743, 2, NumDims.x_Encoders_layer_743);
Vars.x_Encoders_layer_758 = reshape(Vars.x_Encoders_layer_743, dim1, dim2);
Vars.x_Encoders_layer_758 = softmax(Vars.x_Encoders_layer_758, 'DataFormat', 'CB');
Vars.x_Encoders_layer_758 = reshape(Vars.x_Encoders_layer_758, origSize);

% MatMul:
[Vars.x_Encoders_layer_744, NumDims.x_Encoders_layer_744] = onnxMatMul(Vars.x_Encoders_layer_758, Vars.x_Encoders_layer_760, NumDims.x_Encoders_layer_758, NumDims.x_Encoders_layer_760);

% Transpose:
[perm, NumDims.x_Encoders_layer_762] = prepareTransposeArgs(Vars.TransposePerm1292, NumDims.x_Encoders_layer_744);
if ~isempty(perm)
    Vars.x_Encoders_layer_762 = permute(Vars.x_Encoders_layer_744, perm);
end

% Reshape:
[shape, NumDims.x_Encoders_layer_751] = prepareReshapeArgs(Vars.x_Encoders_layer_762, Vars.x_Encoders_layer_727, NumDims.x_Encoders_layer_762, 0);
Vars.x_Encoders_layer_751 = reshape(Vars.x_Encoders_layer_762, shape{:});

% Gemm:
[A, B, C, alpha, beta, NumDims.x_Encoders_layer_742] = prepareGemmArgs(Vars.x_Encoders_layer_751, Vars.Encoders_layers_5__6, Vars.Encoders_layers_5__5, Vars.Gemmalpha1293, Vars.Gemmbeta1294, 0, 1, NumDims.Encoders_layers_5__5);
Vars.x_Encoders_layer_742 = alpha*B*A + beta*C;

% Reshape:
[shape, NumDims.x_Encoders_layer_752] = prepareReshapeArgs(Vars.x_Encoders_layer_742, Vars.x_Encoders_layer_728, NumDims.x_Encoders_layer_742, 0);
Vars.x_Encoders_layer_752 = reshape(Vars.x_Encoders_layer_742, shape{:});

% Transpose:
[perm, NumDims.x_Encoders_layer_763] = prepareTransposeArgs(Vars.TransposePerm1295, NumDims.x_Encoders_layer_752);
if ~isempty(perm)
    Vars.x_Encoders_layer_763 = permute(Vars.x_Encoders_layer_752, perm);
end

% Add:
Vars.x_Encoders_layer_696 = Vars.x_Encoders_layers_4_ + Vars.x_Encoders_layer_763;
NumDims.x_Encoders_layer_696 = max(NumDims.x_Encoders_layers_4_, NumDims.x_Encoders_layer_763);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1296, NumDims.x_Encoders_layer_696);
Vars.x_Encoders_layer_721 = mean(Vars.x_Encoders_layer_696, dims);
NumDims.x_Encoders_layer_721 = NumDims.x_Encoders_layer_696;

% Sub:
Vars.x_Encoders_layer_723 = Vars.x_Encoders_layer_696 - Vars.x_Encoders_layer_721;
NumDims.x_Encoders_layer_723 = max(NumDims.x_Encoders_layer_696, NumDims.x_Encoders_layer_721);

% Pow:
Vars.x_Encoders_layer_719 = power(Vars.x_Encoders_layer_723, Vars.x_Encoders_layer_716);
NumDims.x_Encoders_layer_719 = max(NumDims.x_Encoders_layer_723, NumDims.x_Encoders_layer_716);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1297, NumDims.x_Encoders_layer_719);
Vars.x_Encoders_layer_720 = mean(Vars.x_Encoders_layer_719, dims);
NumDims.x_Encoders_layer_720 = NumDims.x_Encoders_layer_719;

% Add:
Vars.x_Encoders_layer_714 = Vars.x_Encoders_layer_720 + Vars.x_Encoders_layer_715;
NumDims.x_Encoders_layer_714 = max(NumDims.x_Encoders_layer_720, NumDims.x_Encoders_layer_715);

% Sqrt:
Vars.x_Encoders_layer_722 = sqrt(Vars.x_Encoders_layer_714);
NumDims.x_Encoders_layer_722 = NumDims.x_Encoders_layer_714;

% Div:
Vars.x_Encoders_layer_717 = Vars.x_Encoders_layer_723 ./ Vars.x_Encoders_layer_722;
NumDims.x_Encoders_layer_717 = max(NumDims.x_Encoders_layer_723, NumDims.x_Encoders_layer_722);

% Mul:
Vars.x_Encoders_layer_718 = Vars.x_Encoders_layer_717 .* Vars.Encoders_layers_5__4;
NumDims.x_Encoders_layer_718 = max(NumDims.x_Encoders_layer_717, NumDims.Encoders_layers_5__4);

% Add:
Vars.x_Encoders_layer_713 = Vars.x_Encoders_layer_718 + Vars.Encoders_layers_5__3;
NumDims.x_Encoders_layer_713 = max(NumDims.x_Encoders_layer_718, NumDims.Encoders_layers_5__3);

% MatMul:
[Vars.x_Encoders_layer_699, NumDims.x_Encoders_layer_699] = onnxMatMul(Vars.x_Encoders_layer_713, Vars.onnx__MatMul_846, NumDims.x_Encoders_layer_713, NumDims.onnx__MatMul_846);

% Add:
Vars.x_Encoders_layer_698 = Vars.Encoders_layers_5_li + Vars.x_Encoders_layer_699;
NumDims.x_Encoders_layer_698 = max(NumDims.Encoders_layers_5_li, NumDims.x_Encoders_layer_699);

% Relu:
Vars.x_Encoders_layer_697 = relu(Vars.x_Encoders_layer_698);
NumDims.x_Encoders_layer_697 = NumDims.x_Encoders_layer_698;

% MatMul:
[Vars.x_Encoders_layer_701, NumDims.x_Encoders_layer_701] = onnxMatMul(Vars.x_Encoders_layer_697, Vars.onnx__MatMul_847, NumDims.x_Encoders_layer_697, NumDims.onnx__MatMul_847);

% Add:
Vars.x_Encoders_layer_700 = Vars.Encoders_layers_5__1 + Vars.x_Encoders_layer_701;
NumDims.x_Encoders_layer_700 = max(NumDims.Encoders_layers_5__1, NumDims.x_Encoders_layer_701);

% Add:
Vars.x_Encoders_layers_5_ = Vars.x_Encoders_layer_696 + Vars.x_Encoders_layer_700;
NumDims.x_Encoders_layers_5_ = max(NumDims.x_Encoders_layer_696, NumDims.x_Encoders_layer_700);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1298, NumDims.x_Encoders_layers_5_);
Vars.x_norm_ReduceMean_ou = mean(Vars.x_Encoders_layers_5_, dims);
NumDims.x_norm_ReduceMean_ou = NumDims.x_Encoders_layers_5_;

% Sub:
Vars.x_norm_Sub_output_0 = Vars.x_Encoders_layers_5_ - Vars.x_norm_ReduceMean_ou;
NumDims.x_norm_Sub_output_0 = max(NumDims.x_Encoders_layers_5_, NumDims.x_norm_ReduceMean_ou);

% Pow:
Vars.x_norm_Pow_output_0 = power(Vars.x_norm_Sub_output_0, Vars.x_norm_Constant_outp);
NumDims.x_norm_Pow_output_0 = max(NumDims.x_norm_Sub_output_0, NumDims.x_norm_Constant_outp);

% ReduceMean:
dims = prepareReduceArgs(Vars.ReduceMeanAxes1299, NumDims.x_norm_Pow_output_0);
Vars.x_norm_ReduceMean_1_ = mean(Vars.x_norm_Pow_output_0, dims);
NumDims.x_norm_ReduceMean_1_ = NumDims.x_norm_Pow_output_0;

% Add:
Vars.x_norm_Add_output_0 = Vars.x_norm_ReduceMean_1_ + Vars.x_norm_Constant_1_ou;
NumDims.x_norm_Add_output_0 = max(NumDims.x_norm_ReduceMean_1_, NumDims.x_norm_Constant_1_ou);

% Sqrt:
Vars.x_norm_Sqrt_output_0 = sqrt(Vars.x_norm_Add_output_0);
NumDims.x_norm_Sqrt_output_0 = NumDims.x_norm_Add_output_0;

% Div:
Vars.x_norm_Div_output_0 = Vars.x_norm_Sub_output_0 ./ Vars.x_norm_Sqrt_output_0;
NumDims.x_norm_Div_output_0 = max(NumDims.x_norm_Sub_output_0, NumDims.x_norm_Sqrt_output_0);

% Mul:
Vars.x_norm_Mul_output_0 = Vars.x_norm_Div_output_0 .* Vars.norm_weight;
NumDims.x_norm_Mul_output_0 = max(NumDims.x_norm_Div_output_0, NumDims.norm_weight);

% Add:
Vars.x_norm_Add_1_output_ = Vars.x_norm_Mul_output_0 + Vars.norm_bias;
NumDims.x_norm_Add_1_output_ = max(NumDims.x_norm_Mul_output_0, NumDims.norm_bias);

% Gather:
[Vars.x_Gather_output_0, NumDims.x_Gather_output_0] = onnxGather(Vars.x_norm_Add_1_output_, Vars.x_patch_embed_Con_8, 1, NumDims.x_norm_Add_1_output_, NumDims.x_patch_embed_Con_8);

% Gemm:
[A, B, C, alpha, beta, NumDims.output] = prepareGemmArgs(Vars.x_Gather_output_0, Vars.head_weight, Vars.head_bias, Vars.Gemmalpha1300, Vars.Gemmbeta1301, 0, 1, NumDims.head_bias);
Vars.output = alpha*B*A + beta*C;

% Set graph output arguments from Vars and NumDims:
output = Vars.output;
outputNumDims1303 = NumDims.output;
% Set output state from Vars:
state = updateStruct(state, Vars);
end

function [inputDataPerms, outputDataPerms, Training] = parseInputs(x_patch_embed_proj_C, numDataOutputs, params, varargin)
% Function to validate inputs to Mul_To_GemmFcn:
p = inputParser;
isValidArrayInput = @(x)isnumeric(x) || isstring(x);
isValidONNXParameters = @(x)isa(x, 'ONNXParameters');
addRequired(p, 'x_patch_embed_proj_C', isValidArrayInput);
addRequired(p, 'params', isValidONNXParameters);
addParameter(p, 'InputDataPermutation', 'auto');
addParameter(p, 'OutputDataPermutation', 'auto');
addParameter(p, 'Training', false);
parse(p, x_patch_embed_proj_C, params, varargin{:});
inputDataPerms = p.Results.InputDataPermutation;
outputDataPerms = p.Results.OutputDataPermutation;
Training = p.Results.Training;
if isnumeric(inputDataPerms)
    inputDataPerms = {inputDataPerms};
end
if isstring(inputDataPerms) && isscalar(inputDataPerms) || ischar(inputDataPerms)
    inputDataPerms = repmat({inputDataPerms},1,1);
end
if isnumeric(outputDataPerms)
    outputDataPerms = {outputDataPerms};
end
if isstring(outputDataPerms) && isscalar(outputDataPerms) || ischar(outputDataPerms)
    outputDataPerms = repmat({outputDataPerms},1,numDataOutputs);
end
end

function [x_patch_embed_proj_C, Training, outputDataPerms, anyDlarrayInputs] = preprocessInput(x_patch_embed_proj_C, params, varargin)
% Parse input arguments
[inputDataPerms, outputDataPerms, Training] = parseInputs(x_patch_embed_proj_C, 1, params, varargin{:});
anyDlarrayInputs = any(cellfun(@(x)isa(x, 'dlarray'), {x_patch_embed_proj_C}));
% Make the input variables into unlabelled dlarrays:
x_patch_embed_proj_C = makeUnlabeledDlarray(x_patch_embed_proj_C);
% Permute inputs if requested:
x_patch_embed_proj_C = permuteInputVar(x_patch_embed_proj_C, inputDataPerms{1}, 4);
end

function [output] = postprocessOutput(output, outputDataPerms, anyDlarrayInputs, Training, varargin)
% Set output type:
if ~anyDlarrayInputs && ~Training
    if isdlarray(output)
        output = extractdata(output);
    end
end
% Permute outputs if requested:
output = permuteOutputVar(output, outputDataPerms{1}, 2);
end


%% dlarray functions implementing ONNX operators:

function [Y, numDimsY] = onnxConcat(ONNXAxis, XCell, numDimsXArray)
% Concatentation that treats all empties the same. Necessary because
% dlarray.cat does not allow, for example, cat(1, 1x1, 1x0) because the
% second dimension sizes do not match.
numDimsY = numDimsXArray(1);
XCell(cellfun(@isempty, XCell)) = [];
if isempty(XCell)
    Y = dlarray([]);
else
    if ONNXAxis<0
        ONNXAxis = ONNXAxis + numDimsY;
    end
    DLTAxis = numDimsY - ONNXAxis;
    Y = cat(DLTAxis, XCell{:});
end
end

function [Y, numDimsY] = onnxGather(X, ONNXIdx, ONNXAxis, numDimsX, numDimsIdx)
% Function implementing the ONNX Gather operator

% In ONNX, 'Gather' first indexes into dimension ONNXAxis of data, using
% the contents of ONNXIdx as the indices. Then, it reshapes the ONNXAxis
% into the shape of ONNXIdx.
%   Example 1:
% Suppose data has shape [2 3 4 5], ONNXIdx has shape [6 7], and axis=1.
% The result has shape [2 6 7 4 5].
%   Example 2:
% Suppose data has shape [2 3 4 5], ONNXIdx has shape [6], and axis=1.
% The result has shape [2 6 4 5].
%   Example 3:
% Suppose data has shape [2 3 4 5], ONNXIdx has shape [] (a scalar), and axis=1.
% The result has shape [2 4 5].
%
% Since we're using reverse indexing relative to ONNX, in this function
% data and ONNXIdx both have reversed dimension ordering.
numDimsY = numDimsIdx + (numDimsX - 1);
if isempty(X)
    Y = X;
    return;
end
% (1) First, do the subsref part of Gather
if ONNXAxis<0
    ONNXAxis = ONNXAxis + numDimsX;                                 % Axis can be negative. Convert it to its positive equivalent.
end
dltAxis = numDimsX - ONNXAxis;                                      % Convert axis to DLT. ONNXAxis is origin 0 and we index from the end
ONNXIdx(ONNXIdx<0) = ONNXIdx(ONNXIdx<0) + size(X, dltAxis);         % ONNXIdx can have negative components. Make them positive.
dltIdx  = extractdata(ONNXIdx) + 1;                                 % ONNXIdx is origin-0 in ONNX, so add 1 to get dltIdx
% Use subsref to index into data
Indices.subs = repmat({':'}, 1, numDimsX);
Indices.subs{dltAxis} = dltIdx(:);                                  % Index as a column to ensure the output is 1-D in the indexed dimension (for now).
Indices.type = '()';
Y = subsref(X, Indices);
% (2) Now do the reshaping part of Gather
shape = size(Y, 1:numDimsX);
if numDimsIdx == 0
    % Delete the indexed dimension
    shape(dltAxis) = [];
elseif numDimsIdx > 1
    % Reshape the indexed dimension into the shape of ONNXIdx
    shape = [shape(1:dltAxis-1) size(ONNXIdx, 1:numDimsIdx) shape(dltAxis+1:end)];
end
% Extend the shape to 2D so it's valid MATLAB
if numel(shape) < 2
    shape = [shape ones(1,2-numel(shape))];
end
Y = reshape(Y, shape);
end

function [D, numDimsD] = onnxMatMul(A, B, numDimsA, numDimsB)
% Implements the ONNX MatMul operator.

% If either arg is more than 2D, loop over all dimensions before the final
% 2. Inside the loop, perform matrix multiplication.

% If B is 1-D, temporarily extend it to a row vector
if numDimsB==1
    B = B(:)';
end
maxNumDims = max(numDimsA, numDimsB);
numDimsD = maxNumDims;
if maxNumDims > 2
    % sizes of matrices to be multiplied
    matSizeA        = size(A, 1:2);
    matSizeB        = size(B, 1:2);
    % size of the stack of matrices
    stackSizeA      = size(A, 3:maxNumDims);
    stackSizeB      = size(B, 3:maxNumDims);
    % final stack size
    resultStackSize = max(stackSizeA, stackSizeB);
    % full implicitly-expanded sizes
    fullSizeA       = [matSizeA resultStackSize];
    fullSizeB       = [matSizeB resultStackSize];
    resultSize      = [matSizeB(1) matSizeA(2) resultStackSize];
    % Repmat A and B up to the full stack size using implicit expansion
    A = A + zeros(fullSizeA);
    B = B + zeros(fullSizeB);
    % Reshape A and B to flatten the stack dims (all dims after the first 2)
    A2 = reshape(A, size(A,1), size(A,2), []);
    B2 = reshape(B, size(B,1), size(B,2), []);
    % Iterate down the stack dim, doing the 2d matrix multiplications
    D2 = zeros([matSizeB(1), matSizeA(2), size(A2,3)], 'like', A);
    for i = size(A2,3):-1:1
        D2(:,:,i) = B2(:,:,i) * A2(:,:,i);
    end
    % Reshape D2 to the result size (unflatten the stack dims)
    D = reshape(D2, resultSize);
else
    D = B * A;
    if numDimsA==1 || numDimsB==1
        D = D(:);
        numDimsD = 1;
    end
end
end

function [Y, numDimsY] = onnxShape(X, numDimsX)
% Implements the ONNX Shape operator
% Return the reverse ONNX shape as a 1D column vector
switch numDimsX
    case 0
        if isempty(X)
            Y = dlarray(0);
        else
            Y = dlarray(1);
        end
    case 1
        if isempty(X)
            Y = dlarray(0);
        else
            Y = dlarray(size(X,1));
        end
    otherwise
        Y = dlarray(fliplr(size(X, 1:numDimsX))');
end
numDimsY = 1;
end

function [output, numDimsOutput] = onnxWhere(condition, X, Y, numDimsCondition, numDimsX, numDimsY)
bigz = zeros(size(condition + X + Y));      % broadcast
condition = condition + bigz;
X = X + bigz;
output = Y + bigz;
output(condition==1) = X(condition==1);
numDimsOutput = max([numDimsCondition, numDimsX, numDimsY]);
end

function [shape, numDimsY] = prepareExpandArgs(ONNXShape)
% Prepares arguments for implementing the ONNX Expand operator

% Broadcast X to ONNXShape. The shape of X must be compatible with ONNXShape.
ONNXShape = extractdata(ONNXShape);
shape = fliplr(ONNXShape(:)');
if numel(shape) < 2
    shape = [shape ones(1, 2-numel(shape))];
end
numDimsY = numel(ONNXShape);
end

function [A, B, C, alpha, beta, numDimsY] = prepareGemmArgs(A, B, C, alpha, beta, transA, transB, numDimsC)
% Prepares arguments for implementing the ONNX Gemm operator
if transA
    A = A';
end
if transB
    B = B';
end
if numDimsC < 2
    C = C(:);   % C can be broadcast to [N M]. Make C a col vector ([N 1])
end
numDimsY = 2;
% Y=B*A because we want (AB)'=B'A', and B and A are already transposed.
end

function dims = prepareReduceArgs(ONNXAxes, numDimsX)
% Prepares arguments for implementing the ONNX Reduce operator
if isempty(ONNXAxes)
    ONNXAxes = 0:numDimsX-1;   % All axes
end
ONNXAxes(ONNXAxes<0) = ONNXAxes(ONNXAxes<0) + numDimsX;
dims = numDimsX - ONNXAxes;
end

function [DLTShape, numDimsY] = prepareReshapeArgs(X, ONNXShape, numDimsX, allowzero)
% Prepares arguments for implementing the ONNX Reshape operator
ONNXShape = flip(extractdata(ONNXShape));            % First flip the shape to make it correspond to the dimensions of X.
% In ONNX, 0 means "unchanged" if allowzero is false, and -1 means "infer". In DLT, there is no
% "unchanged", and [] means "infer".
DLTShape = num2cell(ONNXShape);                      % Make a cell array so we can include [].
% Replace zeros with the actual size if allowzero is true
if any(ONNXShape==0) && allowzero==0
    i0 = find(ONNXShape==0);
    DLTShape(i0) = num2cell(size(X, numDimsX - numel(ONNXShape) + i0));  % right-align the shape vector and dims
end
if any(ONNXShape == -1)
    % Replace -1 with []
    i = ONNXShape == -1;
    DLTShape{i} = [];
end
if numel(DLTShape)==1
    DLTShape = [DLTShape 1];
end
numDimsY = numel(ONNXShape);
end

function [S, numDimsY] = prepareSliceArgs(X, Starts, Ends, Axes, Steps, numDimsX)
% Prepares arguments for implementing the ONNX Slice operator

% Starts, Ends and Axes are all origin 0. Axes refer to the ONNX dimension
% ordering, but X uses the reverse, DLT ordering. Starts, Ends, Axes, and
% Steps correspond positionally. Axes and Steps may be omitted, with
% defaults described in the ONNX spec.

% Set default Axes and Steps if not supplied
if isempty(Axes)
    Axes = 0:numDimsX-1;   % All axes
end
Axes(Axes<0) = Axes(Axes<0) + numDimsX; % Handle negative Axes.
if isempty(Steps)
    Steps = ones(1, numel(Starts));
end
% Init all dims to :
S.subs = repmat({':'}, 1, numDimsX);
S.type = '()';
% Set Starts and Ends for each axis
for i = 1:numel(Axes)
    DLTDim = numDimsX - Axes(i);                                               % The DLT dim is the reverse of the ONNX dim.
    % "If a negative value is passed for any of the start or end indices,
    % it represents number of elements before the end of that dimension."
    if Starts(i) < 0
        Starts(i) = size(X,DLTDim) + Starts(i);
    end
    if Ends(i) < 0
        Ends(i) = max(-1, size(X,DLTDim) + Ends(i));                        % The -1 case is when we're slicing backward and want to include 0.
    end
    % "If the value passed to start or end is larger than the n (the number
    % of elements in this dimension), it represents n."
    if Starts(i) > size(X,DLTDim)
        Starts(i) = size(X,DLTDim);
    end
    if Ends(i) > size(X,DLTDim)
        Ends(i) = size(X,DLTDim);
    end
    if Steps(i) > 0
        S.subs{DLTDim} = 1 + (Starts(i) : Steps(i) : Ends(i)-1);            % 1 + (Origin 0 indexing with end index excluded)
    else
        S.subs{DLTDim} = 1 + (Starts(i) : Steps(i) : Ends(i)+1);            % 1 + (Origin 0 indexing with end index excluded)
    end
end
numDimsY = numDimsX;
end

function [dim1, dim2, origSize, numDimsX] = prepareSoftmaxArgs(X, ONNXAxis, numDimsX)
% Prepares arguments for implementing the ONNX Softmax operator
if ONNXAxis<0
    ONNXAxis = ONNXAxis + numDimsX;
end
dim2     = prod(size(X, numDimsX+1-ONNXAxis:numDimsX));   % numel on the right
dim1     = numel(X)/dim2;                                 % numel on the left
origSize = size(X);
end

function [perm, numDimsA] = prepareTransposeArgs(ONNXPerm, numDimsA)
% Prepares arguments for implementing the ONNX Transpose operator
if numDimsA <= 1        % Tensors of numDims 0 or 1 are unchanged by ONNX Transpose.
    perm = [];
else
    if isempty(ONNXPerm)        % Empty ONNXPerm means reverse the dimensions.
        perm = numDimsA:-1:1;
    else
        perm = numDimsA-flip(ONNXPerm);
    end
end
end

%% Utility functions:

function s = appendStructs(varargin)
% s = appendStructs(s1, s2,...). Assign all fields in s1, s2,... into s.
if isempty(varargin)
    s = struct;
else
    s = varargin{1};
    for i = 2:numel(varargin)
        fromstr = varargin{i};
        fs = fieldnames(fromstr);
        for j = 1:numel(fs)
            s.(fs{j}) = fromstr.(fs{j});
        end
    end
end
end

function checkInputSize(inputShape, expectedShape, inputName)

if numel(expectedShape)==0
    % The input is a scalar
    if ~isequal(inputShape, [1 1])
        inputSizeStr = makeSizeString(inputShape);
        error(message('nnet_cnn_onnx:onnx:InputNeedsResize',inputName, "[1,1]", inputSizeStr));
    end
elseif numel(expectedShape)==1
    % The input is a vector
    if ~shapeIsColumnVector(inputShape) || ~iSizesMatch({inputShape(1)}, expectedShape)
        expectedShape{2} = 1;
        expectedSizeStr = makeSizeString(expectedShape);
        inputSizeStr = makeSizeString(inputShape);
        error(message('nnet_cnn_onnx:onnx:InputNeedsResize',inputName, expectedSizeStr, inputSizeStr));
    end
else
    % The input has 2 dimensions or more
    
    % The input dimensions have been reversed; flip them back to compare to the
    % expected ONNX shape.
    inputShape = fliplr(inputShape);
    
    % If the expected shape has fewer dims than the input shape, error.
    if numel(expectedShape) < numel(inputShape)
        expectedSizeStr = strjoin(["[", strjoin(string(expectedShape), ","), "]"], "");
        error(message('nnet_cnn_onnx:onnx:InputHasGreaterNDims', inputName, expectedSizeStr));
    end
    
    % Prepad the input shape with trailing ones up to the number of elements in
    % expectedShape
    inputShape = num2cell([ones(1, numel(expectedShape) - length(inputShape)) inputShape]);
    
    % Find the number of variable size dimensions in the expected shape
    numVariableInputs = sum(cellfun(@(x) isa(x, 'char') || isa(x, 'string'), expectedShape));
    
    % Find the number of input dimensions that are not in the expected shape
    % and cannot be represented by a variable dimension
    nonMatchingInputDims = setdiff(string(inputShape), string(expectedShape));
    numNonMatchingInputDims  = numel(nonMatchingInputDims) - numVariableInputs;
    
    expectedSizeStr = makeSizeString(expectedShape);
    inputSizeStr = makeSizeString(inputShape);
    if numNonMatchingInputDims == 0 && ~iSizesMatch(inputShape, expectedShape)
        % The actual and expected input dimensions match, but in
        % a different order. The input needs to be permuted.
        error(message('nnet_cnn_onnx:onnx:InputNeedsPermute',inputName, expectedSizeStr, inputSizeStr));
    elseif numNonMatchingInputDims > 0
        % The actual and expected input sizes do not match.
        error(message('nnet_cnn_onnx:onnx:InputNeedsResize',inputName, expectedSizeStr, inputSizeStr));
    end
end
end

function doesMatch = iSizesMatch(inputShape, expectedShape)
% Check whether the input and expected shapes match, in order.
% Size elements match if (1) the elements are equal, or (2) the expected
% size element is a variable (represented by a character vector or string)
doesMatch = true;
for i=1:numel(inputShape)
    if ~(isequal(inputShape{i},expectedShape{i}) || ischar(expectedShape{i}) || isstring(expectedShape{i}))
        doesMatch = false;
        return
    end
end
end

function sizeStr = makeSizeString(shape)
sizeStr = strjoin(["[", strjoin(string(shape), ","), "]"], "");
end

function isVec = shapeIsColumnVector(shape)
if numel(shape) == 2 && shape(2) == 1
    isVec = true;
else
    isVec = false;
end
end
function X = makeUnlabeledDlarray(X)
% Make numeric X into an unlabelled dlarray
if isa(X, 'dlarray')
    X = stripdims(X);
elseif isnumeric(X)
    if isinteger(X)
        % Make ints double so they can combine with anything without
        % reducing precision
        X = double(X);
    end
    X = dlarray(X);
end
end

function [Vars, NumDims] = packageVariables(params, inputNames, inputValues, inputNumDims)
% inputNames, inputValues are cell arrays. inputRanks is a numeric vector.
Vars = appendStructs(params.Learnables, params.Nonlearnables, params.State);
NumDims = params.NumDimensions;
% Add graph inputs
for i = 1:numel(inputNames)
    Vars.(inputNames{i}) = inputValues{i};
    NumDims.(inputNames{i}) = inputNumDims(i);
end
end

function X = permuteInputVar(X, userDataPerm, onnxNDims)
% Returns reverse-ONNX ordering
if onnxNDims == 0
    return;
elseif onnxNDims == 1 && isvector(X)
    X = X(:);
    return;
elseif isnumeric(userDataPerm)
    % Permute into reverse ONNX ordering
    if numel(userDataPerm) ~= onnxNDims
        error(message('nnet_cnn_onnx:onnx:InputPermutationSize', numel(userDataPerm), onnxNDims));
    end
    perm = fliplr(userDataPerm);
elseif isequal(userDataPerm, 'auto') && onnxNDims == 4
    % Permute MATLAB HWCN to reverse onnx (WHCN)
    perm = [2 1 3 4];
elseif isequal(userDataPerm, 'as-is')
    % Do not permute the input
    perm = 1:ndims(X);
else
    % userDataPerm is either 'none' or 'auto' with no default, which means
    % it's already in onnx ordering, so just make it reverse onnx
    perm = max(2,onnxNDims):-1:1;
end
X = permute(X, perm);
end

function Y = permuteOutputVar(Y, userDataPerm, onnxNDims)
switch onnxNDims
    case 0
        perm = [];
    case 1
        if isnumeric(userDataPerm)
            % Use the user's permutation because Y is a column vector which
            % already matches ONNX.
            perm = userDataPerm;
        elseif isequal(userDataPerm, 'auto')
            % Treat the 1D onnx vector as a 2D column and transpose it
            perm = [2 1];
        else
            % userDataPerm is 'none'. Leave Y alone because it already
            % matches onnx.
            perm = [];
        end
    otherwise
        % ndims >= 2
        if isnumeric(userDataPerm)
            % Use the inverse of the user's permutation. This is not just the
            % flip of the permutation vector.
            perm = onnxNDims + 1 - userDataPerm;
        elseif isequal(userDataPerm, 'auto')
            if onnxNDims == 2
                % Permute reverse ONNX CN to DLT CN (do nothing)
                perm = [];
            elseif onnxNDims == 4
                % Permute reverse onnx (WHCN) to MATLAB HWCN
                perm = [2 1 3 4];
            else
                % User wants the output in ONNX ordering, so just reverse it from
                % reverse onnx
                perm = onnxNDims:-1:1;
            end
        elseif isequal(userDataPerm, 'as-is')
            % Do not permute the input
            perm = 1:ndims(Y);
        else
            % userDataPerm is 'none', so just make it reverse onnx
            perm = onnxNDims:-1:1;
        end
end
if ~isempty(perm)
    Y = permute(Y, perm);
end
end

function s = updateStruct(s, t)
% Set all existing fields in s from fields in t, ignoring extra fields in t.
for name = transpose(fieldnames(s))
    s.(name{1}) = t.(name{1});
end
end
