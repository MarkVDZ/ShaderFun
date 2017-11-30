Shader "Custom/MySurfaceShader" {
	Properties {
		_TextureA ("Texture A", 2D) = "white" {}
		_TextureB ("Texture B", 2D) = "white" {}
		_TextureMask ("TextureMask", 2D) = "white" {}
		_TextureWiggle("TextureWiggle", 2D) = "white" {}

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows
		#pragma vertex vert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _TextureA;
		sampler2D _TextureB;
		sampler2D _TextureMask;
		sampler2D _TextureWiggle;

		struct Input {
			float2 uv_TextureA;
			float2 uv_TextureB;
			float2 uv_TextureMask;
			float2 uv_TextureWiggle;
			fixed4 color : COLOR;
		};

		void vert(inout appdata_full data) {

			half2 uv2d = data.texcoord.xy + half2(_Time.y, _Time.y * .33);

			half4 uv4d = half4(uv2d.x, uv2d.y, 0, 0);
			half4 offset = tex2Dlod(_TextureWiggle, uv4d);

			offset -= half4(.5, .5, .5, .5);

			data.vertex += offset * 10;
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input data, inout SurfaceOutputStandard o) {

			fixed4 color1 = tex2D(_TextureA, data.uv_TextureA);
			fixed4 color2 = tex2D(_TextureB, data.uv_TextureB);
			fixed4 color3 = tex2D(_TextureMask, data.uv_TextureMask);

			fixed threshold = (sin(_Time.y) + 1) / 2;

			if (color3.r > threshold) {
				o.Albedo = color1;
			}
			else {
				o.Albedo = color2;
				//o.Emission = color2 * 20;
			}

			//o.Albedo = lerp(color1, color2, color3.r);
			//o.Albedo = color1.rgb * color2.rgb;

			//o.Albedo = lerp(color1, color2, data.color);
			o.Metallic = 0;
			o.Smoothness = 0;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
