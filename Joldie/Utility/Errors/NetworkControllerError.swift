//
//  NetworkControllerError.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

enum NetworkControllerError: ErrorProtocol {
    case LoginError
    case GetUserError
    case GetCellarsError
    case GetCircuitsError
    case GetBrandsError
    case GetRestosError
    case GetHotelsError
    case GetCountriesError
    case GetJurisdictionsError
    case GetZonesError
    case GetOpinionLikeError
    case GetOpinionError
    case CreateOpinionError
    case GetRatingError
    case GetEntityRatingError
    case GetFavoriteError
    case CreateRatingError
    case CreateOpinionLikeError
    case SearchError
    case GetOpinionsCountError
    case GetFeaturedError
    case GetEntityError
    
    case GetCollectionError
    case Unknown
    
    var code: Int {
        switch self {
        case .LoginError: return 201
        case .GetUserError: return 202
        case .GetCellarsError: return 203
        case .GetCircuitsError: return 204
        case .GetBrandsError: return 205
        case .GetRestosError: return 206
        case .GetHotelsError: return 207
        case .GetCountriesError: return 208
        case .GetJurisdictionsError: return 209
        case .GetZonesError: return 210
        case .GetOpinionLikeError: return 211
        case .GetOpinionError: return 212
        case .CreateOpinionError: return 213
        case .GetRatingError: return 214
        case .GetEntityRatingError: return 215
        case .GetFavoriteError: return 216
        case .CreateRatingError: return 217
        case .CreateOpinionLikeError: return 218
        case .SearchError: return 219
        case .GetOpinionsCountError: return 220
        case .GetFeaturedError: return 221
        case .GetEntityError: return 222
            
        case .GetCollectionError: return 300
        case .Unknown: return -999
        }
    }
    
    var userInfo: [NSObject : AnyObject] {
        let ld: String!
        
        switch self {
        case .LoginError:             ld = "Error at login"
        case .GetUserError:           ld = "Error getting user"
        case .GetCellarsError:        ld = "Error getting cellars"
        case .GetCircuitsError:       ld = "Error getting circuits"
        case .GetBrandsError:         ld = "Error getting brands"
        case .GetRestosError:         ld = "Error getting restos"
        case .GetHotelsError:         ld = "Error getting hotels"
        case .GetCountriesError:      ld = "Error getting countries"
        case .GetJurisdictionsError:  ld = "Error getting jurisdictions"
        case .GetZonesError:          ld = "Error getting zones"
        case .GetOpinionLikeError:    ld = "Error getting opinion like"
        case .GetOpinionError:        ld = "Error getting opinion"
        case .CreateOpinionError:     ld = "Error creating opinion"
        case .GetRatingError:         ld = "Error getting rating"
        case .GetEntityRatingError:   ld = "Error getting entity rating"
        case .GetFavoriteError:       ld = "Error getting favorite"
        case .CreateRatingError:      ld = "Error creating rating"
        case .CreateOpinionLikeError: ld = "Error creating opinion like"
        case .SearchError:            ld = "Error on search"
        case .GetOpinionsCountError:  ld = "Error getting opinions count"
        case .GetFeaturedError:       ld = "Error getting featured entities"
        case .GetEntityError:         ld = "Error getting entity"
            
        case .GetCollectionError:     ld = "Error getting collection"
        case .Unknown:                ld = "Network unknown error"
        }
        
        return [NSLocalizedDescriptionKey as NSObject : ld as AnyObject as AnyObject]
    }
}
