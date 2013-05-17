using System;
using System.Runtime.InteropServices;
using System.Threading;
using Microsoft.SharePoint;

namespace Demo.WebTemplateFeature.Features.SaskTelProjectSiteMasterPage
{
    /// <summary>
    /// This class handles events raised during feature activation, deactivation, installation, uninstallation, and upgrade.
    /// </summary>
    /// <remarks>
    /// The GUID attached to this class may be used during packaging and should not be modified.
    /// </remarks>
    [Guid("b8cb199a-b13b-4c51-8087-11144ed3d843")]
    public class SaskTelProjectSiteMasterPageEventReceiver : SPFeatureReceiver
    {
        private const int MAXRETRY = 10;

        public override void FeatureActivated(SPFeatureReceiverProperties properties)
        {
            SPSite site = (SPSite)properties.Feature.Parent;

            int retries = 0;
            bool isSuccessful = false;

            while (retries++ < MAXRETRY && !isSuccessful)
            {
                isSuccessful = CheckinAndApproveMasterPage(site);
            }

            // TODO: LH, log feature activation failure
        }


        // Uncomment the method below to handle the event raised before a feature is deactivated.

        //public override void FeatureDeactivating(SPFeatureReceiverProperties properties)
        //{
        //}


        // Uncomment the method below to handle the event raised after a feature has been installed.

        //public override void FeatureInstalled(SPFeatureReceiverProperties properties)
        //{
        //}


        // Uncomment the method below to handle the event raised before a feature is uninstalled.

        //public override void FeatureUninstalling(SPFeatureReceiverProperties properties)
        //{
        //}

        // Uncomment the method below to handle the event raised when a feature is upgrading.

        //public override void FeatureUpgrading(SPFeatureReceiverProperties properties, string upgradeActionName, System.Collections.Generic.IDictionary<string, string> parameters)
        //{
        //}

        #region Private Methods

        private bool CheckinAndApproveMasterPage(SPSite site)
        {
            Thread.Sleep(300);

            try
            {
                SPList masterPageGallery = site.GetCatalog(SPListTemplateType.MasterPageCatalog);
                foreach (SPListItem li in masterPageGallery.Items)
                {
                    if (li.File.Name.ToLower() == "v4_sasktel.master")
                    {
                        if (!li.HasPublishedVersion)
                        {
                            li.File.CheckIn("Automatically checked in on SaskTel Project Site Template activation",
                                            SPCheckinType.MajorCheckIn);
                            li.File.Update();

                            li.File.Approve("Automatically approved on SaskTel Project Site Template activation");
                            li.File.Update();
                        }
                    }
                }

                return true;
            }
            catch
            {
                // TODO: LH, log exception 
                return false;
            }
        }

        #endregion
    }
}
