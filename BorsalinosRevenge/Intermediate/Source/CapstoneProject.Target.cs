using UnrealBuildTool;

public class CapstoneProjectTarget : TargetRules
{
	public CapstoneProjectTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;
		ExtraModuleNames.Add("CapstoneProject");
	}
}
