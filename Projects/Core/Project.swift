import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
	name: "Core",
	product: .staticFramework,
	dependencies: [
		.SPM.Moya,
		.Project.Utils
	],
	sources: ["Sources/**"]
)
