import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
	name: "Utils",
	product: .framework,
	dependencies: [
		
	],
	sources: ["Sources/**"]
)
