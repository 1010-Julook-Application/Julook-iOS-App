import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
	name: "Common",
	product: .staticFramework,
	dependencies: [
		
	],
	sources: ["Sources/**"]
)
