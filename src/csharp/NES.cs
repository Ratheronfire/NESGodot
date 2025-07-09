using Godot;
using System;

public partial class NES : Node
{
    public static NES Instance { get; private set; }

    public override void _Ready()
    {
        Instance = this;
        cpu = CPUMemory.Instance;
    }


    public override void _Process(double delta)
    {
        Console.WriteLine("C#");
    }
}
