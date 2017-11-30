Shader "Custom/MyVertFragShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SwellAmount ("Swell Amount", Range(0, 100)) = 5.0
		_SwellSpeed ("Swell Speed", Range(0, 10)) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _SwellAmount;
			fixed _SwellSpeed;
			
			v2f vert (appdata v)
			{
				v2f o;
				float dis = (sin(_Time.y * _SwellSpeed) + 1) * _SwellAmount;

				dis *= v.color.r;

				v.vertex += v.normal * dis;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//o.uv = v.uv;
				o.uv.x += _Time.y;

				o.color = v.color;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = i.color;
				return col;
			}
			ENDCG
		}
	}
}
