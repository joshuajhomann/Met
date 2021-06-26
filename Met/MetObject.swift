//
//  MetObject.swift
//  Met
//
//  Created by Joshua Homann on 6/26/21.
//

import Foundation

// MARK: - MetObject
struct MetObject: Codable, Identifiable {
    var id: Int { objectID }
    var objectID: Int
    var isHighlight: Bool
    var accessionNumber, accessionYear: String
    var isPublicDomain: Bool
    var primaryImage, primaryImageSmall: String
    var additionalImages: [String]
    var constituents: [Constituent]?
    var department, objectName, title, culture: String
    var period, dynasty, reign, portfolio: String
    var artistRole, artistPrefix, artistDisplayName, artistDisplayBio: String
    var artistSuffix, artistAlphaSort, artistNationality, artistBeginDate: String
    var artistEndDate, artistGender: String
    var artistWikidataURL: String
    var artistULANURL: String
    var objectDate: String
    var objectBeginDate, objectEndDate: Int
    var medium, dimensions: String
    var measurements: [Measurement]?
    var creditLine, geographyType, city, state: String
    var county, country, region, subregion: String
    var locale, locus, excavation, river: String
    var classification, rightsAndReproduction, linkResource, metadataDate: String
    var repository: String
    var objectURL: String
    var tags: [Tag]
    var objectWikidataURL: String
    var isTimelineWork: Bool
    var galleryNumber: String

    enum CodingKeys: String, CodingKey {
        case objectID, isHighlight, accessionNumber, accessionYear, isPublicDomain, primaryImage, primaryImageSmall, additionalImages, constituents, department, objectName, title, culture, period, dynasty, reign, portfolio, artistRole, artistPrefix, artistDisplayName, artistDisplayBio, artistSuffix, artistAlphaSort, artistNationality, artistBeginDate, artistEndDate, artistGender
        case artistWikidataURL = "artistWikidata_URL"
        case artistULANURL = "artistULAN_URL"
        case objectDate, objectBeginDate, objectEndDate, medium, dimensions, measurements, creditLine, geographyType, city, state, county, country, region, subregion, locale, locus, excavation, river, classification, rightsAndReproduction, linkResource, metadataDate, repository, objectURL, tags
        case objectWikidataURL = "objectWikidata_URL"
        case isTimelineWork
        case galleryNumber = "GalleryNumber"
    }
    // MARK: - Constituent
    struct Constituent: Codable {
        var constituentID: Int
        var role, name: String
        var constituentULANURL: String
        var constituentWikidataURL: String
        var gender: String

        enum CodingKeys: String, CodingKey {
            case constituentID, role, name
            case constituentULANURL = "constituentULAN_URL"
            case constituentWikidataURL = "constituentWikidata_URL"
            case gender
        }
    }

    // MARK: - Measurement
    struct Measurement: Codable {
        var elementName: String
        var elementDescription: String?
        var elementMeasurements: ElementMeasurements?
    }

    // MARK: - ElementMeasurements
    struct ElementMeasurements: Codable {
        var height, width: Double?
        var depth: Double?

        enum CodingKeys: String, CodingKey {
            case height = "Height"
            case width = "Width"
            case depth = "Depth"
        }
    }

    // MARK: - Tag
    struct Tag: Codable {
        var term: String?
        var aatURL: String?
        var wikidataURL: String?

        enum CodingKeys: String, CodingKey {
            case term
            case aatURL = "AAT_URL"
            case wikidataURL = "Wikidata_URL"
        }
    }
}

