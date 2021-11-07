import Foundation

class HydrationInteractor {
    
    private static let RecommendedValue = HydrationValue(value: 2000, unitType: .milliliters)
    
    private static let Controls: [HydrationLevelDescription] =
        [
           HydrationLevelDescription(
               value: HydrationValue(value: 150, unitType: .milliliters),
               color: .Dynamic.Solid.SoftRed,
               image: "Drop"
           ),
           HydrationLevelDescription(
            value: HydrationValue(value: 250, unitType: .milliliters),
            color: .Dynamic.Solid.SoftDeepOrange,
            image: "Cup"
           ),
           HydrationLevelDescription(
            value: HydrationValue(value: 500, unitType: .milliliters),
            color: .Dynamic.Solid.SoftBlue,
            image: "Glass"
           ),
           HydrationLevelDescription(
            value: HydrationValue(value: 850, unitType: .milliliters),
            color: .Dynamic.Solid.SoftDeepPurple,
            image: "Blender"
           )
       ]
    
    private let hydrationSettingsRepository: HydrationSettingsRepository
    private let hydrationDataRepository: HydrationMillilitresDataRepository
    
    init(hydrationSettingsRepository: HydrationSettingsRepository,
         hydrationDataRepository: HydrationMillilitresDataRepository) {
        self.hydrationSettingsRepository = hydrationSettingsRepository
        self.hydrationDataRepository = hydrationDataRepository
    }
    
    var selectedUnit: UnitType {
        get {
            return hydrationSettingsRepository.hydrationUnits
        }
        set {
            hydrationSettingsRepository.hydrationUnits = newValue
        }
    }
    
    var recommendedValue: HydrationValue {
        let selectedUnit = hydrationSettingsRepository.hydrationUnits
        return HydrationInteractor.RecommendedValue.changeUnitType(newUnitType: selectedUnit)
    }
    
    var todayValue: HydrationValue {
        let selectedUnit = hydrationSettingsRepository.hydrationUnits
        return HydrationValue(value: hydrationDataRepository.todayValue, unitType: .milliliters).changeUnitType(newUnitType: selectedUnit)
    }
    
    var todayProgress: Double {        
        let value = todayValue.value
        let recommendedValue = recommendedValue.value
        
        return value / recommendedValue
    }
    
    var availableUnits: [UnitType] {
        return UnitType.allCases
    }
    
    var availableLevels: [HydrationLevelDescription] {
        let selectedUnit = hydrationSettingsRepository.hydrationUnits
        
        return HydrationInteractor.Controls.map {
            return HydrationLevelDescription(value: $0.value.changeUnitType(newUnitType: selectedUnit), color: $0.color, image: $0.image)
        }
    }
    
    func updateProgress(diff: Double, unit: UnitType) {
        let currentUnitConverter = unit.toUnitConverter(rawValue: diff)
        hydrationDataRepository.updateValue(diff: currentUnitConverter.toMilliliters().value)
    }
    
}
