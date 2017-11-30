using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyPostProcessScript : MonoBehaviour
{
    public Shader shader;
    private Material mat;
    public Texture wigglyTexture;
    // Use this for initialization
    void Start()
    {
        mat = new Material(shader);
        mat.SetTexture("_WiggleTex", wigglyTexture);

    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        //src.wrapMode = TextureWrapMode.Repeat;
        Graphics.Blit(src, dst, mat);

    }
}
