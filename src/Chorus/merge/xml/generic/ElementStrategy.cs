using System;
using System.Collections.Generic;
using System.Xml;
using Chorus.merge.xml.generic;

namespace Chorus.merge.xml.generic
{
	/// <summary>
	/// each element-type can have custom merging code
	/// </summary>
	public class MergeStrategies
	{
		/// <summary>
		/// the list of custom strategies that have been installed
		/// </summary>
		public Dictionary<string, ElementStrategy> ElementStrategies{get;set;}

		public MergeStrategies()
		{
			 ElementStrategies= new Dictionary<string, ElementStrategy>();
			ElementStrategy s = new ElementStrategy(true);//review: this says the default is to consder order relevant
			s.MergePartnerFinder = new FindTextDumb();
			this.SetStrategy("_"+XmlNodeType.Text, s);

			ElementStrategy def = new ElementStrategy(true);//review: this says the default is to consder order relevant
			def.MergePartnerFinder = new FindByEqualityOfTree();
			this.SetStrategy("_defaultElement", def);
		}

		public void SetStrategy(string key, ElementStrategy strategy)
		{
			ElementStrategies[key] = strategy;
		}

		public ElementStrategy GetElementStrategy(XmlNode element)
		{
			string name;
			switch (element.NodeType)
			{
				case XmlNodeType.Element:
					name = element.Name;
					break;
				default:
					name = "_"+element.NodeType;
					break;
			}

			ElementStrategy strategy;
			if (!ElementStrategies.TryGetValue(name, out strategy))
			{
				return ElementStrategies["_defaultElement"];
			}
			return strategy;
		}

		public IFindNodeToMerge GetMergePartnerFinder(XmlNode element)
		{
			return GetElementStrategy(element).MergePartnerFinder;
		}

//        private IMergeReportMaker GetDifferenceReportMaker(XmlNode element)
//        {
//            ElementStrategy strategy;
//            if (!this._mergeStrategies.ElementStrategies.TryGetValue(element.Name, out strategy))
//            {
//                return new DefaultMergeReportMaker();
//            }
//            return strategy.mergeReportMaker;
//        }

	}

	public class ElementStrategy
	{
		/// <summary>
		/// Given a node in "ours" that we want to merge with "theirs", how do we identify the one in "theirs"?
		/// </summary>
		public IFindNodeToMerge MergePartnerFinder{ get; set;}

		//is this a level of the xml file that would consitute the minimal unit conflict-understanding
		//from a user perspecitve?
		//e.g., in a dictionary, this is the lexical entry.  In a text, it might be  a paragraph.
		public IGenerateContextDescriptor ContextDescriptorGenerator { get; set; }

		public  ElementStrategy(bool orderIsRelevant)
		{
			OrderIsRelevant = orderIsRelevant;
			AttributesToIgnoreForMerging = new List<string>();
		}


		/// <summary>
		/// Is the order of this element among its peers relevant (this says nothing about its children)
		/// </summary>
		public bool OrderIsRelevant { get; set; }

		public List<string> AttributesToIgnoreForMerging{get; private set;}

		public static ElementStrategy CreateForKeyedElement(string keyAttributeName, bool orderIsRelevant)
		{
			ElementStrategy strategy = new ElementStrategy(orderIsRelevant);
			strategy.MergePartnerFinder = new FindByKeyAttribute(keyAttributeName);
			return strategy;
		}

		/// <summary>
		/// Declare that there can only be a single element with this name in a list of children
		/// </summary>
		public static ElementStrategy CreateSingletonElement()
		{
			ElementStrategy strategy = new ElementStrategy(false);
			strategy.MergePartnerFinder = new FindFirstElementWithSameName();
			return strategy;
		}

		public string GetHumanDescription(XmlNode element)
		{
			return "not implemented";
		}

//        public string GetConflictContextIfAppropriate(XmlNode element)
//        {
//            return null;
//        }

	}

	//Given an element (however that is defined for a given file type (e.g. xml element for xml files)...
	//create a descriptor that can be used later to find the element again, as when reviewing conflict.
	//for an xml file, this can be an xpath.
	//I note that while this is tying to be generic, it probably won't work as-is for really simple text files,
	//which would want a line number, not the contents of the line.
	public interface IGenerateContextDescriptor
	{
		string GenerateContextDescriptor(string mergeElement);
	}
}