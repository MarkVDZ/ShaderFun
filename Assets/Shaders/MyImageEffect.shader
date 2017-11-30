Shader "Hidden/MyImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_WiggleTex("WiggleTex", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _WiggleTex;

			fixed4 frag (v2f i) : SV_Target
			{
				//i.uv.x += _Time.y;
				fixed4 col = tex2D(_WiggleTex, i.uv + half2(_Time.y, _Time.y * .33));
				fixed2 finalUV = (col.rg - .5) * .1;
				fixed4 color2 = tex2D(_MainTex, i.uv + finalUV);

				color2 += half4(1, 0, 0, 0) * (sin(_Time.y) + 1) / 2;
				//return lerp(col, color2, col.r);
				return color2;
				//return col;
			}
			ENDCG
		}
	}
}
