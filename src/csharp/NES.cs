using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;

public partial class NES : Node
{
    public const double NTSC_SECONDS_PER_CYCLE = 0.0000005589;
    public const double PAL_SECONDS_PER_CYCLE = 0.0000006015;

    public const double NTSC_CYCLES_PER_SCANLINE = 113.6666666667;
    public const double PAL_CYCLES_PER_SCANLINE = 106.5625;

    public const int NTSC_SCANLINES = 240;
    public const int PAL_SCANLINES = 239;

    public const int NTSC_VBLANK_SCANLINES = 20;
    public const int PAL_VBLANK_SCANLINES = 70;

    /// <summary>
    /// The number of CPU instructions to run per second. -1 to run at max speed, 0 to run by manual steps only.
    /// </summary>
    [Export]
    public int instructionsPerSecond = 0;

    /// <summary>
    /// Sets the speed of the emulated CPU. 1.0 equals the default value (60fps for NTSC/50fps for PAL), and 0.0 means the CPU is stopped.
    /// </summary>
    [Export]
    public double cpuSpeedMultiplier = 0.0;

    [Export]
    public bool verboseOutput = false;

    [Export]
    public int ThreadRunsPerFrame = 10000;

    public static NES Instance { get; private set; }

    private Consts.Interrupts pendingInterrupt;

    private CPUMemory cpu;

    private PPUMemory ppu;


    public int cycles { get; private set; }
    public int scanline { get; private set; }
    public int frame { get; private set; }

    private double nextFrameStartTime = 0.0;
    private double secondsThisCycle = 0.0;
    private double secondsThisScanline = 0.0;

    private bool nmiStarted = false;

    private int nmiVector;
    private int resetVector;
    private int irqVector;

    private bool isRunning = false;

    private Thread cpuThread;

    [Signal]
    public delegate void TickedEventHandler();

    [Signal]
    public delegate void RenderStartEventHandler();

    [Signal]
    public delegate void RenderEndEventHandler();


    public override void _Ready()
    {
        Instance = this;

        cpu = CPUMemory.Instance;
        ppu = PPUMemory.Instance;
    }

    public void Init()
    {
        cpu.Init(CPUMemory.CPU_MEMORY_SIZE);
        ppu.Init(PPUMemory.PPU_MEMORY_SIZE);
    }

    private Task CpuLoop()
    {
        var lastTick = Time.GetTicksMsec();

        var runs = 0;

        while (isRunning)
        {
            runs += 1;
            if (runs >= ThreadRunsPerFrame)
            {
                runs = 0;
                yield return null;
            }
        }
    }
}
